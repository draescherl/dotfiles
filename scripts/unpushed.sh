#!/usr/bin/env bash

# Git Repository Push Status Checker
# This script finds all git repositories and checks if they have unpushed commits

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default search directory (home directory)
SEARCH_DIR="${1:-$HOME}"

echo -e "${BLUE}Checking git repositories for unpushed commits...${NC}"
echo -e "${BLUE}Search directory: $(realpath "$SEARCH_DIR")${NC}"
echo "----------------------------------------"

# Find all .git directories (indicating git repositories)
repos_with_issues=0
total_repos=0

# Use find to locate all .git directories, excluding specified directories and .git inside other .git dirs
while IFS= read -r -d '' git_dir; do
    repo_dir=$(dirname "$git_dir")
    repo_name=$(basename "$repo_dir")
    
    total_repos=$((total_repos + 1))
    
    echo -e "\n${BLUE}Checking: $repo_name${NC} ($(realpath "$repo_dir"))"
    
    # Change to the repository directory
    cd "$repo_dir" || continue
    
    # Check if it's actually a git repository
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        echo -e "${RED}  ✗ Not a valid git repository${NC}"
        repos_with_issues=$((repos_with_issues + 1))
        continue
    fi
    
    # Check if there are any commits
    if ! git rev-parse HEAD >/dev/null 2>&1; then
        echo -e "${YELLOW}  ⚠ No commits found${NC}"
        continue
    fi
    
    # Get current branch
    current_branch=$(git branch --show-current 2>/dev/null)
    if [ -z "$current_branch" ]; then
        echo -e "${YELLOW}  ⚠ Detached HEAD state${NC}"
        continue
    fi
    
    # Check if remote exists
    remote=$(git remote 2>/dev/null | head -n1)
    if [ -z "$remote" ]; then
        echo -e "${YELLOW}  ⚠ No remote configured${NC}"
        repos_with_issues=$((repos_with_issues + 1))
        continue
    fi
    
    # Check if current branch has a remote tracking branch
    upstream=$(git rev-parse --abbrev-ref "$current_branch@{upstream}" 2>/dev/null)
    if [ -z "$upstream" ]; then
        echo -e "${YELLOW}  ⚠ Branch '$current_branch' has no upstream branch${NC}"
        repos_with_issues=$((repos_with_issues + 1))
        continue
    fi
    
    # Fetch to get latest remote information (quietly)
    echo "  Fetching latest remote information..."
    if ! git fetch --quiet 2>/dev/null; then
        echo -e "${RED}  ✗ Failed to fetch from remote${NC}"
        repos_with_issues=$((repos_with_issues + 1))
        continue
    fi
    
    # Check if local branch is ahead of remote
    ahead=$(git rev-list --count "$upstream".."$current_branch" 2>/dev/null)
    behind=$(git rev-list --count "$current_branch".."$upstream" 2>/dev/null)
    
    if [ "$ahead" -gt 0 ]; then
        echo -e "${RED}  ✗ Branch '$current_branch' is $ahead commit(s) ahead of '$upstream'${NC}"
        repos_with_issues=$((repos_with_issues + 1))
        
        # Show the unpushed commits
        echo -e "${YELLOW}  Unpushed commits:${NC}"
        git log --oneline "$upstream".."$current_branch" | sed 's/^/    /'
    else
        echo -e "${GREEN}  ✓ Branch '$current_branch' is up to date with '$upstream'${NC}"
    fi
    
    if [ "$behind" -gt 0 ]; then
        echo -e "${YELLOW}  ⚠ Branch '$current_branch' is $behind commit(s) behind '$upstream'${NC}"
    fi
    
    # Check for uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        echo -e "${YELLOW}  ⚠ Uncommitted changes present${NC}"
    fi
    
    # Check for untracked files
    untracked=$(git ls-files --others --exclude-standard)
    if [ -n "$untracked" ]; then
        echo -e "${YELLOW}  ⚠ Untracked files present${NC}"
    fi
    
done < <(find "$SEARCH_DIR" -name ".git" -type d \
    -not -path "*/.cache/*" \
    -not -path "*/.local/*" \
    -not -path "*/JetBrains/*" \
    -not -path "*/.cargo/*" \
    -print0 2>/dev/null)

# Summary
echo ""
echo "========================================"
echo -e "${BLUE}Summary:${NC}"
echo "Total repositories checked: $total_repos"

if [ $repos_with_issues -eq 0 ]; then
    echo -e "${GREEN}✓ All repositories are up to date!${NC}"
else
    echo -e "${RED}✗ $repos_with_issues repository(ies) need attention${NC}"
fi

# Return appropriate exit code
exit $repos_with_issues
