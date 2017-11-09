using GLib;
using Pluie;

/**
 * a Class representing a set of {@link Color}
 * mapping {@link ECHO} colors with values coming from
 * the specifyed ini config file
 **/
public class Pluie.ColorConf
{

    const char             KF_LIST_SEP = ',';
    
    string                 path;
    GLib.KeyFile           kf;
    string[]               keys;
    Array<Color>           colors      = new Array<Color> ();

    /**
     * see resources/echo.ini file
     * @param path config ini file path overriding Pluie.ECHO color values
     **/
    public ColorConf(string path)
    {
        Dbg.in (Log.METHOD, "path:'%s'".printf (path), Log.LINE, Log.FILE);
        this.path = path;
        this.load_config();
        Dbg.out (Log.METHOD, null, Log.LINE, Log.FILE);
    }

    /**
     * get specifiyed ECHO color instance
     * @param name the choosen color
     * @return the corresponding Color instance
     **/
    public new unowned Color? @get (ECHO name)
    {
        unowned Color c = this.colors.index ((int)name);
        return c;
    }


    private void load_config (string? path = null)
    {
        Dbg.in (Log.METHOD, null, Log.LINE, Log.FILE);
        this.kf = new KeyFile ();
        Dbg.msg ("loading file", Log.LINE, Log.FILE);
        this.kf.set_list_separator (ColorConf.KF_LIST_SEP);
        try {
            this.kf.load_from_file (path == null ? this.path : path, KeyFileFlags.NONE);
            this.keys = kf.get_keys ("Colors");
            this.colors.set_size((uint) keys.length);
            for (var i = 0; i < this.keys.length ; i++) {
                this.colors.insert_val ((uint) i, this.load_color (this.keys[i])); 
            }
        }
        catch (KeyFileError e) {
            Dbg.error (e.message, Log.METHOD, Log.LINE, Log.FILE);
        }
        catch (FileError e) {
            Dbg.error (e.message, Log.METHOD, Log.LINE, Log.FILE);
        }
        Dbg.out (Log.METHOD, null, Log.LINE, Log.FILE);
    }


    private string get_config (string key, string group = "Colors")
    {
        string v = "";
        try {
            v = this.kf.get_string (group, key);
        }
        catch (GLib.KeyFileError e) {
            Dbg.error (e.message, Log.METHOD, Log.LINE, Log.FILE);
        }
        return v;
    }

    /**
     * get value for Term parameter
     * @param name from { "term_width", "indent", "key_maxlen" }
     * @return corresponding value define in config file
     **/
    public int param (string name)
    {
        string[] plist = { "term_width", "indent", "key_maxlen" };
        int val = 0;
        if (name in plist) {
            val = int.parse (this.get_config (name, "Term"));
        }
        return val;
    }


    private Color load_color(string name)
    {
        uint8?   fg     = null;
        uint8?   bg     = null;
        bool     bold   = false;
        string[] params = this.get_config(name).split(",");
        if (params.length >= 3) {
            bg   = (uint8) int.parse(params[2]);
        }
        if (params.length >= 2) {
            bold = (bool) int.parse(params[1]);
        }
        if (params.length >= 1) {
            fg   = (uint8) int.parse(params[0]);
        }
        return new Color(fg, bold, bg);
    }
}
