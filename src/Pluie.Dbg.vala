using GLib;

namespace Pluie.Dbg
{

    static OutputFormatter o;
    public static bool DBG_ENABLED = false;
    public const int8  DBG_ENTER   = 1;
    public const int8  DBG_LEAVE   = 2;
    public const int8  DBG_INLINE  = 0;
    public const int8  DBG_ERROR   = 8;
    public const int8  DBG_WARN    = 9;


    public void init (OutputFormatter of, bool debug = false)
    {
        o = of;
        Pluie.Dbg.DBG_ENABLED = debug;
    }


    private string parse_params (string? params)
    {
        string str = "";
        if (DBG_ENABLED) {
            if (params != null) {
                string[] list = params.split(":");
                string   sep  = "";
                for (var i = 0; i < list.length; i++) {
                    str += sep + o.c (i % 2 == 0 ? ECHO.KEY : ECHO.VAL).s (list[i] == "(null)" ? "null" : (list[i]));
                    sep = i % 2 == 1 ? ", " : ":";
                }
            }
        }
        return str;
    }

    public static void @in(string method, string? params = null, int line = 0, string? file = null)
    {
        Dbg.log ("%s (%s)".printf (method, Dbg.parse_params(params)), line, DBG_ENTER, file);
    }


    public static void @out(string method, string? params = null, int line = 0, string? file = null)
    {
        Dbg.log ("%s (%s)".printf (method, Dbg.parse_params(params)), line, DBG_LEAVE, file);
    }


    public static void msg(string msg, int line = 0, string? file = null)
    {
        Dbg.log (msg, line, DBG_INLINE, file);
    }


    public static void @error(string msg, string method, int line = 0, string? file = null, int8 mode = DBG_ERROR)
    {
        Dbg.log (file != null ? "%s %s (in %s)".printf (msg, Color.off (), method) : msg, line, mode, file == null ? "%s".printf (method) : file);
    }


    private static string dbg_label_mode (int8 mode)
    {
        string label;
        switch (mode) {
            case DBG_ENTER  : label = o.c (ECHO.ENTER).s ("> "); break;
            case DBG_LEAVE  : label = o.c (ECHO.LEAVE).s ("< "); break;            
            case DBG_ERROR  : label = o.c (ECHO.ERROR).s (" Error: ", false); break;
            case DBG_WARN   : label = o.c (ECHO.WARN ).s (" Warn: ", false); break;
            default         : label = "  "; break;
        }
        return label;
    }


    public static void log (string msg, int line = 0, int8 mode = DBG_INLINE, string? file = null)
    {
        if (DBG_ENABLED) {
            var time = new DateTime.now_local ();
            stderr.printf (
                "%s%s%s%s%s%s%s%s%s %s\n",
                o.c (ECHO.ARG ).s ("["),
                o.c (ECHO.DATE).s (time.format ("%H:%M")),
                o.c (ECHO.TIME).s (time.format (":%S")),
                o.c (ECHO.MICROTIME).s (".%d".printf (time.get_microsecond ())),
                file != null ? o.c (ECHO.COMMENT).s (" "+file) : "",
                line > 0 && (mode != DBG_INLINE || file != null) ? o.c (ECHO.NUM).s (":%d".printf (line)) : "",
                o.c (ECHO.ARG).s ("] "),
                dbg_label_mode(mode),
                line > 0 && mode  == DBG_INLINE && file == null  ? o.c (ECHO.NUM).s ("%d: ".printf (line))+msg : msg,
                Color.off ()
            );
        }
    }

}
