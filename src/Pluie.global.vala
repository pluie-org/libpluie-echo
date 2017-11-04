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
        public void init (bool debug, string path, out OutputFormatter of)
        {
            var conf = new ColorConf (path);
            of       = new OutputFormatter (conf);
            Dbg.init (of, debug);
        }
    }
}
