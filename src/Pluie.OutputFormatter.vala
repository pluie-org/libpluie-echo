using GLib;
using Pluie;

/**
 * A class managing display on stdout & stderror with {@link Color} styles defined by
 * specifiyed {@link ColorConf}
 *
 * {{{
 * using GLib;
 * using Pluie;
 *
 * errordomain MyError {
 *     CODE
 * }
 *
 * int main (string[] args)
 * {
 *     var of = Echo.init (true, "resources/echo.ini");
 *     Dbg.in (Log.METHOD, null, Log.LINE, Log.FILE);
 *
 *     of.title ("MyApp", "0.2.2", "a-sansara");
 *
 *     of.echo ("sample echo\n");
 *
 *     of.keyval ("path", "/tmp/blob");
 *     of.keyval ("otherlongoption", "other value");
 *
 *     of.echo ("\nsample echo\non multiple\nline", true, true);
 *
 *     of.action ("reading config", "toto.conf");
 *
 *     of.state (false);
 *
 *     of.warn ("boloss warning");
 *     of.echo ();
 *
 *     var cmd = new Sys.Cmd ("ls -la");
 *
 *     int status = cmd.run();
 *     of.action ("running cmd", cmd.name);
 *     of.echo ("\n%s".printf (cmd.output), true, true);
 *
 *     of.state (status == 0);
 *
 *     try {
 *         throw new MyError.CODE("this is the error message");
 *     }
 *     catch (MyError e) {
 *         of.error (e.message);
 *     }
 *     of.rs (true);
 *     of.rs (true, "ok");
 *     of.rs (false, "", "exit");
 *
 *     of.echo();
 *
 *     string com   = "Vala is syntactically similar to C# and includes several features such as: anonymous functions, signals, properties, generics, assisted memory management, exception handling, type inference, and foreach statements.[3] Its developers Jürg Billeter and Raffaele Sandrini aim to bring these features to the plain C runtime with little overhead and no special runtime support by targeting the GObject object system";
 *     string mycom = of.wordwrap (com, of.term_width-44);
 *     int    line  = mycom.split("\n").length;
 *     of.echo (mycom, true, true, ECHO.COMMENT, 40);
 *
 *     of.usage_option ("quiet", "q", "SHUTUP", false, line);
 *     of.echo();
 *
 *     of.echo (mycom, true, true, ECHO.COMMENT, 40);
 *     of.usage_option ("record-desktop", "r", "TIME", false, line);
 *
 *     of.echo();
 *     Dbg.out (Log.METHOD, null, Log.LINE, Log.FILE);
 *     return 0;
 * }
 *
 * }}}
 * valac --pkg pluie-echo-0.1 outputFormatter.vala
 **/
public class Pluie.OutputFormatter
{

    string     sep          = "──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────";
    string     space        = "                                                                                                                                                                                  ";
    string     symbol       = "➤";
    /**
     * number of space defining default indentation
     **/
    public int indent;
    /**
     * max terminal with to considerate when printing messages
     **/
    public int term_width;
    /**
     * max padding to use for keys in {@see OutputFormatter.keyval} method
     **/
    int        key_maxlen;
    protected  ColorConf  conf;

    /**
     * @param conf the ColorConf to use for printing ansi escape sequences
     **/
    public OutputFormatter (ColorConf conf)
    {
        this.conf       = conf;
        this.term_width = conf.param("term_width");
        this.indent     = conf.param("indent");
        this.key_maxlen = conf.param("key_maxlen");
    }

    /**
     * get Color instance corresponding to ECHO color
     * @param name the ECHO color
     **/
    public unowned Color c (ECHO name)
    {
        unowned Color color = this.conf.get (name);
        return color;
    }

    /**
     * get ansi escape sequence moving up lines
     * @param line number of line to move up
     **/
    public string move_up (int line)
    {
        return "\033[%dA".printf (line);
    }

    /**
     * get ansi escape sequence moving down lines
     * @param line number of line to move down
     **/
    public string move_down (int line)
    {
        return "\033[%dB".printf (line);
    }


    protected Color test (bool exp, bool error = false)
    {
        return !error ? (exp ? this.c (ECHO.DONE) : this.c (ECHO.FAIL)) : (exp ? this.c (ECHO.ERROR) : this.c (ECHO.WARN));
    }

    /**
     * get an indentation only string
     * @param adjust number of space indentation adjustment
     **/
    public string s_indent (int8 adjust = 0)
    {
        return "%.*s".printf (this.indent+adjust, this.space);
    }


    protected string title_sep ()
    {
        return this.c (ECHO.TITLE_SEP).s (" %.*s".printf ((this.term_width-1)*3, this.sep));
    }

    /**
     * display a title
     * @param label generally title of program
     * @param version version of  program
     * @param author author of  program
     **/
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

    /**
     * display an action
     * @param name name of current action
     * @param val optional action parameter
     **/
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

    /**
     * display a warning
     * @param label the warn message to display
     **/
    public void warn (string label)
    {
        this.error (label, true);
    }

    /**
     * display an error
     * @param label the error message to display
     **/
    public void error (string label, bool warn = false)
    {
        stderr.printf (
            "\n%s%s\n",
            this.s_indent (-2),
            this.test(!warn, true).s (" %s : %s ".printf (warn ? "warn" : "error", label))
        );
    }

    /**
     * display a test result
     * @param test the result of test
     * @param done the done label to display if test succeed
     * @param done the fail label to display if test fail
     **/
    public void rs (bool test, string done = "done", string fail = "fail")
    {
        stdout.printf (
            "\n%s%s\n",
            this.s_indent (-2),
            this.test (test).s ("  %s  ".printf (test ? done : fail))
        );
    }

    /**
     * display a message up tp x lines
     * @param line number of line to move up
     * @param s the message to display
     **/
    public void echo_up (int line, string s)
    {
        stdout.printf ("%s\r%s%s\r", this.move_up(line), s, this.move_down(line));
    }

    /**
     * generic method to display messages
     * @param data the message to display
     * @param lf enable line feed
     * @param indent_all enable multiple line indentation
     * @param color use color ECHO to display the message
     **/
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

    /**
     * display a state for specifiyed test
     * @param test the test result
     **/
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

    /**
     * wordwrap paragraph
     * @param str the paragraph to wordwrap
     * @param width maximum width of each lines
     * @param cut cur word rather than wordwrap [not implemented]
     **/
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

    /**
     * display usage option
     * @param name the option name
     * @param shortname the option shortname
     * @param argname the option argument
     * @param val specifyed optional value argument
     * @param echo_up line to move up on displaying option definition
     **/
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

    /**
     * display a key value message
     * @param key the key name
     * @param val the key value
     **/
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
