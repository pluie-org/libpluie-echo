using Pluie;

int main (string[] args)
{
    var c1 = new Color( 37, false);
    var c2 = new Color(204, true);
    var c3 = new Color( 15, true, 24);
    stdout.printf ("[%s][%s]%s\n", c1.s ("oki"), c2.s ("it's"), c3.s ("  cool  "));
    return 0;
}
