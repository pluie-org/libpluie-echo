using GLib;
using Pluie;

/**
 * A class spawning synchronous command line
 * 
 * {{{
 * using Pluie;
 *
 * int main (string[] args)
 * {
 *     Echo.init(false);
 *     var cmd = new Sys.Cmd ("ls -la");
 *     return cmd.run(true);
 * }
 * }}}
 * valac --pkg pluie-echo-0.2 pluie-cmd.vala
 **/
public class Pluie.Sys.Cmd
{
    /**
     * last command standard output
     **/
    public string output { get; private set; }
    /**
     * last command error output
     **/
    public string error  { get; private set; }
    /**
     * last command line
     **/
    public string name   { get; private set; }
    /**
     * last command line status
     **/
    public int    status { get; private set; }

    /**
     * @param   name optionnal command line
     **/
    public Cmd (string name = "")
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

    /**
     * run the current command or a new one
     *
     * @param   display enable/disable stdout output
     * @param   name optionnal - redefine command line to run
     * @return  command line status
     **/
    public int run (bool display = false, string name = "")
    {
        Dbg.in (Log.METHOD, "display:%d:name:'%s'".printf ((int)display, name), Log.LINE, Log.FILE);
        try {
            if (name != "") {
                this.init_cmd (name);
            }
            if (this.name != "") {
                int s; string o, e;
                Process.spawn_command_line_sync (this.name, out o, out e, out s);
                this.status = s;
                this.output = o;
                this.error  = e;
                if (display) {
                    of.action ("runing cmd", this.name);
                    of.echo (this.output);
                    of.state (this.status == 0);
                }
            }
            else {
                this.status = 1;
                this.error  = this.output = "no command";
            }
        }
        catch (SpawnError e) {
            stderr.printf ("%s\n", e.message);
        }
        Dbg.out (Log.METHOD, "status:%d".printf (this.status), Log.LINE, Log.FILE);
        return this.status;
    }

}
