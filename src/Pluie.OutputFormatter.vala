using GLib;
using Pluie;

public class Pluie.OutputFormatter
{

    string     sep          = "──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────";
    string     space        = "                                                                                                                                                                                  ";
    string     symbol       = "➤";
    public int indent;
    public int term_width;
    int        key_maxlen;
    protected  ColorConf  conf;


    public OutputFormatter (ColorConf conf)
    {
        this.conf       = conf;
        this.term_width = conf.param("term_width");
        this.indent     = conf.param("indent");
        this.key_maxlen = conf.param("key_maxlen");
    }


    public unowned Color c (ECHO name)
    {
        unowned Color color = this.conf.get (name);
        return color;
    }


    public string move_up (int line)
    {
        return "\033[%dA".printf (line);
    }


    public string move_down (int line)
    {
        return "\033[%dB".printf (line);
    }


    protected Color test (bool exp, bool error = false)
    {
        return !error ? (exp ? this.c (ECHO.DONE) : this.c (ECHO.FAIL)) : (exp ? this.c (ECHO.ERROR) : this.c (ECHO.WARN));
    }


    public string s_indent (int8 adjust = 0)
    {
        return "%.*s".printf (this.indent+adjust, this.space);
    }


    protected string title_sep ()
    {
        return this.c (ECHO.TITLE_SEP).s (" %.*s".printf ((this.term_width-1)*3, this.sep));
    }


    public void title (string label, string? version = null, string? author = null)
    {
        string s = version == null ? " " : this.c (ECHO.TITLE_ITEM).s (" v" + version+" ", false);
        if (author != null) {
            s += "%s %s".printf (this.c (ECHO.TITLE).s ("| by", false, false), this.c (ECHO.TITLE_ITEM).s (author, false));
        }
        stdout.printf (
            "\n%s\n  %s%s  %s\n%s\n", 
            this.title_sep (),
            this.c (ECHO.TITLE).s ("  "+label, false), 
            s, 
            Color.off (),
            this.title_sep ()
        );
    }


    public void action (string name, string? val = "")
    {
        stdout.printf (
            "\n%s%s %s %s\n",
            this.s_indent (-2),
            this.c (ECHO.ITEM  ).s (this.symbol, false), 
            this.c (ECHO.ACTION).s (name, false), 
            this.c (ECHO.VAL   ).s (val)
        );
    }


    public void warn (string label)
    {
        this.error (label, true);
    }


    public void error (string label, bool warn = false)
    {
        stderr.printf (
            "\n%s%s\n",
            this.s_indent (-2),
            this.test(!warn, true).s (" %s : %s ".printf (warn ? "warn" : "error", label))
        );
    }


    public void rs (bool test, string done = "done", string fail = "fail")
    {
        stdout.printf (
            "\n%s%s\n",
            this.s_indent (-2),
            this.test (test).s ("  %s  ".printf (test ? done : fail))
        );
    }


    public void echo_up (int line, string s)
    {
        stdout.printf ("%s\r%s%s\r", this.move_up(line), s, this.move_down(line));
    }


    public void echo (string? data = "", bool lf = true, bool indent_all = false, ECHO color = ECHO.DEFAULT, int8 indent_adjust = 0)
    {
        string s;
        if (indent_all) {
            var  b     = new StringBuilder ();
            bool begin = true;
            foreach (string line in data.split ("\n")) {
                b.append (begin ? "" : "\n%s".printf (this.s_indent (indent_adjust)));
                b.append (line);
                if (begin) begin = false;
            }
            s = b.str;
        }
        else s = data;

        stdout.printf (
            "%s%s%s%s", 
            this.s_indent (indent_adjust),
            this.c (color).s (s, false), 
            lf ? "\n" : "",
            Color.off ()
        );
    }


    public void state (bool test)
    {
        int len = (this.term_width)*3 - 14 - this.indent-3;
        stdout.printf (
            "%s%.*s %s\n", 
            this.s_indent (),
            len, 
            this.c (ECHO.SEP).s (this.sep),
            this.test (test).s ("  %s  ".printf (test ? "OK" : "KO"))
        );
    }


    public string wordwrap (string str, int width, bool cut = false)
    {
        unichar c;
        int     char_count       = 0;
        int     line_offset      = 0;
        int     last_line_offset = 0;
        int     last_offset      = 0;
        int     space_pos        = 0;
        int     space_offset     = 0;
        unichar space            = ' ';
        var     sb               = new StringBuilder();
        for (int offset = 0; str.get_next_char (ref offset, out c); char_count++) {
            if (char_count > width) {
                line_offset = c == space ? offset : space_offset+1;
                char_count  = width - (c == space ? width+1 : space_pos);
                sb.append ((string) str[last_line_offset:line_offset]);
                sb.append ("\n");
                last_line_offset = line_offset;
            }
            if (c == space) {
                space_pos    = char_count;
                space_offset = last_offset;
            }
            last_offset = offset;
        }
        sb.append ((string) str[line_offset:last_offset]);
        return sb.str;
    }


    public void usage_option (string? name = null, string? shortname=null, string? argname = null, bool val = false, int echo_up = 0)
    {
        string opt = "";
        string arg = "";
        if (shortname != null) {
            opt = "%s%s%s".printf (
                this.c (ECHO.OPTION).s ("-"), 
                this.c (ECHO.OPTION).s (shortname),
                name != null ? this.c (ECHO.OPTION_SEP).s (", --") : ""
            );
        }
        if (name != null) {
            opt += this.c (ECHO.OPTION).s (name);
        }
        if (argname != null) {
            arg = "  %s%s%s".printf (
                !val ? this.c (ECHO.ARG_SEP).s ("[") : "",
                this.c (ECHO.ARG).s (argname),
                !val ? this.c (ECHO.ARG_SEP).s ("]") : ""
            );
        }
        if (echo_up > 0) {
            this.echo_up (echo_up, "%s%s%s".printf (this.s_indent(), opt, arg));
        }
        else {
            stdout.printf ("%s%s%s\n", this.s_indent(), opt, arg);
        }
    }


    public void keyval (string key, string val)
    {
        int len = this.key_maxlen - (int) key.length;
        stdout.printf (
            "%s      %s "+@" %$(len)s  : %s\n", 
            this.s_indent (),
            this.c (ECHO.KEY).s (key), 
            " ", 
            this.c (ECHO.VAL).s (val)
        );
    }

}
