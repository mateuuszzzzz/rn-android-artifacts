# GH CLI setup (assuming it is already installed)

1. Go to Settings > Developer Settings > Personal access tokens > Tokens (classic)
2. Create token with scopes `repo`, `read:org`, `gist`, `read:packages`.
3. Save it to `token.txt`
4. Type in terminal: `gh auth login --with-token < token.txt`
5. Remove `token.txt`
6. `gh auth status` should show your account data



# Building app with prebuilt artifacts (if hash of current hashes is in `mappings.json`, otherwise it fallbacks to build from source)
1. `npm i`
2. `npm run android`
