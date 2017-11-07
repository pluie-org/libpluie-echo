using GLib;
using Pluie;

namespace Pluie
{
    public enum ECHO
    {
        DEFAULT,
        COMMENT,
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
    
    namespace Echo
    {
        public static OutputFormatter of;

        public OutputFormatter init (bool debug, string? path = null)
        {
            var conf = new ColorConf (path ?? Path.build_filename (DATA_PATH, "echo.ini"));
            Echo.of = new OutputFormatter (conf);
            Dbg.init (Echo.of, debug);
            return Echo.of;
        }
    }
}
