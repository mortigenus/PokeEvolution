# About:
The App uses Poke API v2 to show the list of initial pokémon species. Tapping a pokémon shows it's evolution chain.

# Notes:
- We work with pokémon *species* as initial list. (Saves us doing additional request to get evolution info.)
- We load all pokémon from the beginning, as the list of all pokémon is less than 1k elements, consist of only a name and an url, and we do not anticipate this list to change. If we were at least provided with some basic info to show, we could consider adding pagination support. The whole list is 7.5 KB.
- If there's no evolutions for a pokémon, we show an empty list.
- There's no error handling.
- Normally I would use an rx framework to bind view models, so the way it is done here might be a bit clunky.
- Caching is done using URLCache. Reloading pokémon list with pull to refresh clears the cache.
