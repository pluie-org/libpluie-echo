using GLib;

public class Pluie.Sys.Cmd
{

    public string output { get; private set; }
    public string error  { get; private set; }
    public string name   { get; private set; }
    public int    status { get; private set; }

    
    public Cmd (string name)
    {
        Dbg.in (Log.METHOD, "name:'%s'".printf (name), Log.LINE, Log.FILE);
        this.init_cmd (name);
        Dbg.out (Log.METHOD, null, Log.LINE, Log.FILE);
    }


    private void init_cmd (string name)
    {
        Dbg.in (Log.METHOD, "name:'%s'".printf (name), Log.LINE, Log.FILE);
        this.name   = name;
        this.output = null;
        this.error  = null;
        this.status = -1;
        Dbg.out (Log.METHOD, null, Log.LINE, Log.FILE);
    }


    public int run (bool display = false, string? name = null)
    {
        Dbg.in (Log.METHOD, "display:%d:name:'%s'".printf ((int)display, name), Log.LINE, Log.FILE);
        try {
            if (name != null) {
                this.init_cmd (name);
            }
            int s; string o, e;
            Process.spawn_command_line_sync (this.name, out o, out e, out s);
            this.status = s;
            this.output = o;
            this.error  = e;
            if (display) {
                stdout.printf ("runing %s :\n%s", this.name, this.output);
            }
        }
        catch (SpawnError e) {
            stderr.printf ("%s\n", e.message);
        }
        Dbg.out (Log.METHOD, "status:%d".printf (this.status), Log.LINE, Log.FILE);
        return this.status;
    }

}
