# PostEverywhere.s.sol

**⚠️ WARNING: This is an absurd toy project born out of ennui. Do not use this. ⚠️**

A Solidity script that posts to multiple social media platforms via curl from within a Foundry script. Yes, really.

## What this does

Posts the same message to:

- Mastodon
- X (Twitter)
- Bluesky

## Usage

Don't. But if you must:

```bash
# Set environment variables for API tokens
export MASTODON_ACCESS_TOKEN="your_token"
export MASTODON_INSTANCE="https://your.instance"
export X_BEARER_TOKEN="your_token"
export BLUESKY_BEARER="your_token"
export BLUESKY_HANDLE="your.handle"

# Post a message
forge script script/PostEverywhere.s.sol --sig 'run(string)' 'Your message here'
```

## Why this exists

Boredom, too much coffee, and other questionable life choices.

## Should you use this?

No. Use proper APIs and tools for social media automation. This is just a demonstration that you _can_ do ridiculous things with Solidity scripts, not that you _should_, actually, you _shouldn't_.
