using Pluie;

int main (string[] args)
{
    Echo.init(false);
    var cmd = new Sys.Cmd ("ls -la");
    return cmd.run(true);
}
