using GLib;
using Pluie;

/**
 * root namespace of various pluie library
 **/
namespace Pluie
{
    /**
     * enumerate predefined {@link Color} mapped to default config file
     * see resources/echo.ini
     **/
    public enum ECHO
    {
        DEFAULT,
        COMMENT,
        COMMAND,
        PARAM,
        BIN,
        OPTION,
        OPTION_SEP,
        ARG,
        ARG_SEP,
        TITLE,
        TITLE_ITEM,
        TITLE_SEP,
        SECTION,
        SEP,
        ITEM,
        ACTION,
        DONE,
        FAIL,
        KEY,
        VAL,
        DATE,
        TIME,
        MICROTIME,
        FILE,
        NUM,
        ENTER,
        LEAVE,
        WARN,
        ERROR;
    }

    /**
     * default OutputFormatter
     **/
    public static OutputFormatter of;

    /**
     * Echo namespace
     **/
    namespace Echo
    {
        /**
         * initialize lib pluie-echo
         * @param   debug enable/disable traces
         * @param   path optional - redefine config file used to load ColorConf
         **/
        public static OutputFormatter init (bool debug, string? path = null)
        {
            var conf = new ColorConf (path ?? Path.build_filename (DATA_PATH, "echo.ini"));
            Pluie.of = new OutputFormatter (conf);
            Dbg.init (debug);
            return Pluie.of;
        }
    }
}
