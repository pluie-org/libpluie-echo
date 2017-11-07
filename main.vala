using GLib;
using Pluie;

errordomain MyError {
    CODE
}

int main (string[] args)
{
    var of = Echo.init (true, "resources/echo.ini");
    Dbg.in (Log.METHOD, null, Log.LINE, Log.FILE);

    of.title ("MyApp", "0.2.2", "a-sansara");
    
    of.echo ("sample echo\n");
    
    of.keyval ("path", "/tmp/blob");
    of.keyval ("otherlongoption", "other value");
    
    of.echo ("\nsample echo\non multiple\nline", true, true);
    
    of.action ("reading config", "toto.conf");
    
    of.state (false);
    
    of.warn ("boloss warning");
    of.echo ();

    var cmd = new Sys.Cmd ("ls -la");

    int status = cmd.run();    
    of.action ("running cmd", cmd.name);
    of.echo ("\n%s".printf (cmd.output), true, true);
    
    of.state (status == 0);
    
    try {
        throw new MyError.CODE("this is the error message");
    }
    catch (MyError e) {
        of.error (e.message);
    }
    of.rs (true);
    of.rs (true, "ok");
    of.rs (false, "", "exit");
    
    of.echo();
    
    string com   = "Vala is syntactically similar to C# and includes several features such as: anonymous functions, signals, properties, generics, assisted memory management, exception handling, type inference, and foreach statements.[3] Its developers Jürg Billeter and Raffaele Sandrini aim to bring these features to the plain C runtime with little overhead and no special runtime support by targeting the GObject object system";
    string mycom = of.wordwrap (com, of.term_width-44);
    int    line  = mycom.split("\n").length;
    of.echo (mycom, true, true, ECHO.COMMENT, 40);
    
    of.usage_option ("quiet", "q", "SHUTUP", false, line);
    of.echo();
    
    of.echo (mycom, true, true, ECHO.COMMENT, 40);
    of.usage_option ("record-desktop", "r", "TIME", false, line);

    of.echo();
    Dbg.out (Log.METHOD, null, Log.LINE, Log.FILE);
    return 0;
}
