using GLib;
using Pluie;

/**
 * Dbg namespace with convenient static methods used to display traces
 **/
namespace Pluie.Dbg
{
    /**
     * enable/disable log messages
     **/
    public static bool DBG_ENABLED = false;
    const int8  DBG_ENTER   = 1;
    const int8  DBG_LEAVE   = 2;
    const int8  DBG_INLINE  = 0;
    /**
     * type log error
     **/
    public const int8  DBG_ERROR   = 8;
    /**
     * type log warn
     **/
    public const int8  DBG_WARN    = 9;

    /**
     * initialize logging
     * @param debug enable disable log messages
     **/
    public static void init (bool debug = false)
    {
        Pluie.Dbg.DBG_ENABLED = debug;
    }


    private static string parse_params (string? params)
    {
        string str = "";
        if (DBG_ENABLED) {
            if (params != null) {
                string[] list = params.split(":");
                string   sep  = "";
                for (var i = 0; i < list.length; i++) {
                    str += sep + of.c (i % 2 == 0 ? ECHO.KEY : ECHO.VAL).s (list[i] == "(null)" ? "null" : (list[i]));
                    sep = i % 2 == 1 ? ", " : ":";
                }
            }
        }
        return str;
    }

    /**
     * log method entering
     * @param method the method name
     * @param parameters optional parameters string to display on entering method
     * @param line optional current file line
     * @param file optional current file
     **/
    public static void @in(string method, string? parameters = null, int line = 0, string? file = null)
    {
        Dbg.log ("%s (%s)".printf (method, Dbg.parse_params(parameters)), line, DBG_ENTER, file);
    }

    /**
     * log method leaving
     * @param method the method name
     * @param parameters optional parameters string to display on leaving method
     * @param line optional current file line
     * @param file optional current file
     **/
    public static void @out(string method, string? parameters = null, int line = 0, string? file = null)
    {
        Dbg.log ("%s (%s)".printf (method, Dbg.parse_params(parameters)), line, DBG_LEAVE, file);
    }

    /**
     * log a message
     * @param msg the msg to log
     * @param line optional current file line
     * @param file optional current file
     **/
    public static void msg(string msg, int line = 0, string? file = null)
    {
        Dbg.log (msg, line, DBG_INLINE, file);
    }

    /**
     * log error
     * @param msg  the error msg to log
     * @param method  the method name logging the error
     * @param line optional current file line
     * @param file optional current file
     * @param mode optional log mode (DBG_ERROR|DBG_WARN)
     **/
    public static void @error(string msg, string method, int line = 0, string? file = null, int8 mode = DBG_ERROR)
    {
        Dbg.log (file != null ? "%s %s (in %s)".printf (msg, Color.off (), method) : msg, line, mode, file == null ? "%s".printf (method) : file);
    }


    private static string dbg_label_mode (int8 mode)
    {
        string label;
        switch (mode) {
            case DBG_ENTER  : label = of.c (ECHO.ENTER).s ("> "); break;
            case DBG_LEAVE  : label = of.c (ECHO.LEAVE).s ("< "); break;
            case DBG_ERROR  : label = of.c (ECHO.ERROR).s (" Error: ", false); break;
            case DBG_WARN   : label = of.c (ECHO.WARN ).s (" Warn: ", false); break;
            default         : label = "  "; break;
        }
        return label;
    }


    private static void log (string msg, int line = 0, int8 mode = DBG_INLINE, string? file = null)
    {
        if (DBG_ENABLED) {
            var time = new DateTime.now_local ();
            stderr.printf (
                "%s%s%s%s%s%s%s%s%s %s\n",
                of.c (ECHO.ARG ).s ("["),
                of.c (ECHO.DATE).s (time.format ("%H:%M")),
                of.c (ECHO.TIME).s (time.format (":%S")),
                of.c (ECHO.MICROTIME).s (".%d".printf (time.get_microsecond ())),
                file != null ? of.c (ECHO.COMMENT).s (" "+file) : "",
                line > 0 && (mode != DBG_INLINE || file != null) ? of.c (ECHO.NUM).s (":%d".printf (line)) : "",
                of.c (ECHO.ARG).s ("] "),
                dbg_label_mode(mode),
                line > 0 && mode  == DBG_INLINE && file == null  ? of.c (ECHO.NUM).s ("%d: ".printf (line))+msg : msg,
                Color.off ()
            );
        }
    }

}
