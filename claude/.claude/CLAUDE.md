## Environment-specific instructions

- My private SSH key is stored on a yubikey. Therefore you MUST warn me before calling a tool which uses SSH (SSH itself, git fetch/pull/push, ...) so that I can be ready to touch the key for approval.

## Code comments

Do not write these kinds of comments:
- Comments which paraphrase the code it sits next to, unless the code is a non trivial algorithm. Good comments explain the WHY not the HOW.
- Comments which only make sense in the context of our discussion history. If our back and forth discussion is removed and the comment becomes confusing then drop it.
- Comments which reference itemized lists from our conversation. For example:
    ```
    /// The dedicated provisioning's single transaction (#3767 fortification
    /// C5, finding F6, [`crate::outbox`]): the `provision` row and its mode's
    /// table (`addon`), the `provision_database` row (`database`) and the
    /// BDS START into `postgresql_outbox` (`start`) — all or nothing, so a
    /// VM is never booted for a row that did not land
    /// ([`crate::db::insert_dedicated_with_start`]).
    ```
   The comment above references C5 and F6 but these have never been defined. They are confusing for a future reader.

## Writing style

- Be as concise as possible.
- Use itemized lists rather than long sentences.
- Minimize technical jargon.
- No conversational filler. Skip agreement openers, apologies and self-corrections, and state the fact or the fix directly.
- Remove clear LLM markers from text: no em-dashes, minimal usage of semicolons, ...
