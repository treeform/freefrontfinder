## Free Font Finder API

This repo contains a mapping of font names to font urls.

There are two json and csv files full of entries you can scan for fonts and
find their URLs so that you can download them and use them.

## font.json

If you have font name "Tinos" and you know its "italic" at weight 400, and you
want to get the actual .ttf you can download the json file with:

```
https://raw.githubusercontent.com/treeform/freefrontfinder/master/fonts.json
```

```json
{
    "name": "Tinos",
    "ps_name": "Tinos-Italic",
    "weight": 400,
    "style": "italic",
    "license": "APACHE2",
    "url": "https://github.com/google/fonts/blob/master/ofl/tinos/Tinos-Italic.ttf?raw=true"
}
```

## font.csv

```
https://raw.githubusercontent.com/treeform/freefrontfinder/master/fonts.csv
```

Some times you have a Post Script Name. With PS name already contains the style
and weight information so it might be easier to use csv file:

```
Tinos-Italic,https://github.com/google/fonts/blob/master/ofl/tinos/Tinos-Italic.ttf?raw=true,APACHE2
```
