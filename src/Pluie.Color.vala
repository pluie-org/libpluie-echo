public class Pluie.Color
{

    public uint8? fg   { get; set; default = 15;   }
    public uint8? bg   { get; set; default = null; }
    public bool   bold { get; set; default = false; }


    public Color (uint8? fg = 15, bool bold = false, uint8? bg = null)
    {
        this.fg   = fg;
        this.bg   = bg;
        this.bold = bold;
    }


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


    public static string off ()
    {
        return "\033[m";
    }

}
