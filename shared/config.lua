CONFIG = {
    ---The rate of refresh of the unit blips.
    ---I would recommend letting this value to 1500-3500 due a high value can cause a network thread overflow.
    REFRESH_RATE = 3000,

    ---The colors that the units can set to theirselves when using the blips.
    ---You can check what colors are available here: https://docs.fivem.net/docs/game-references/blips/#blip-colors
    ---You can change the index of the color to make it a more accessible command parameter.
    ALLOWED_COLORS = {
        ['1']  = 1,
        ['3']  = 3,
    },
    EVENT_PREFIX     = '__jobblips_ton__:',
    DEBUG_ENABLED    = true,
    ---Here include first the framework and then the framework resource name like in the example below. If you use QB for example, add {'qbcore', 'qb-core'} instead of the default one.
    FRAMEWORK        = {'esx', 'es_extended'}, ---'esx', 'qbcore' or 'custom (If you choose custom, you need to edit the file named `framework.lua` in the `server` folder)'.
    JOBS             = {'police', 'ambulance'}, ---The jobs that need to see the blips to cooperate between themselves.
    LOCALES          = {
        ['NOT_ALLOWED'] = 'You are not allowed to use this command',
        ['NOT_COLOR']   = 'This color does not exist',
    },
    COMMANDS         = {
        {'enablerefs', 'Listen references without appearing in the map'},
        {'ref', 'Enable/disable references'},
        {'updatecolor', 'Update the color (Requires the color argument)'},
        {'removerefs', 'Disable and remove references'},
    }
}