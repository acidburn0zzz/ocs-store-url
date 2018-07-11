# Internationalization

ocs-url/i18n/ is sub project for program internationalization.


## Localization for program

Using two tools lupdate and lrelease to make translation.

Text is gathered from program source files and included in QM files for translation along with other resource files.

### Creating TS (Translation Source) files

To generate TS files, sets TS file name to definition TRANSLATIONS in i18n.pro and run lupdate with i18n.pro.

    $ cd /path/to/ocs-url/i18n/
    $ lupdate i18n.pro

Then adds translations to the generated TS files using Qt Linguist or text editor.

### Creating QM (Qt Message) files

To generate QM files, run lrelease with i18n.pro.

    $ cd /path/to/ocs-url/i18n/
    $ lrelease i18n.pro

Then adds the path of the generated QM files to i18n.qrc.
