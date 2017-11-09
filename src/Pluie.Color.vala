/**
 * a Class representing an Ansi Extended 8 bit Color
 * with foreground, background and bold attributes
 *
 * {{{
 * using Pluie;
 *
 * int main (string[] args)
 * {
 *     var c1 = new Color(37, false);
 *     var c2 = new Color(204, true);
 *     var c3 = new Color(15, true, 24);
 *     stdout.printf ("[%s][%s]  %s  ", c1.s ("oki"), c2.s ("very"), c3.s ("cool"));
 *     return 0;
 * }
 * }}}
 *
 * valac --pkg pluie-echo-0.1 color.vala
 **/
public class Pluie.Color
{
    /**
     * foreground color code - 0 to 255
     **/
    public uint8? fg   { get; set; default = 15;   }
    /**
     * background color code - 0 to 255
     **/
    public uint8? bg   { get; set; default = null; }
    /**
     * enable bold attribute
     **/
    public bool   bold { get; set; default = false; }

    /**
     * @param fg   foreground color code - 0 to 255
     * @param bold bold attribute
     * @param bg   background color code - 0 to 255
     **/
    public Color (uint8? fg = 15, bool bold = false, uint8? bg = null)
    {
        this.fg   = fg;
        this.bg   = bg;
        this.bold = bold;
    }

    /**
     * return ansi extended color escape string sequence
     **/
    public string to_string ()
    {
        string s = "\033[%s%sm".printf (
            this.bg == null ? "%d;".printf ((int) this.bold) 
                            : "%d;48;5;%u%s".printf ((int) this.bold, this.bg, this.fg != null ? ";" : ""),
            this.fg == null ? ""
                            : "38;5;%u".printf (this.fg)
        );
        return s;
    }

    /**
     * colorize a string
     * @param label the string to colorize
     * @param off enable/disable off sequence at end of label
     * @param bold override bold attribute for label
     * @return the colorized string with proper ansi escape color sequence
     **/
    public string s (string? label = null, bool off = true, bool? bold = null)
    {
        bool prevbold = this.bold;
        if (bold != null) {
            this.bold = bold;
        }
        string s = label == null || label == "" ? ( off ? Color.off () : "") : this.echo (label, off);
        if (bold != null) {
            this.bold = prevbold;
        }
        return s;
    }


    private string echo (string label, bool off = true)
    {
        return "%s%s%s".printf (this.to_string (), label, off ? Color.off() : "");
    }

    /**
     * disable escape color sequence
     **/
    public static string off ()
    {
        return "\033[m";
    }

}
