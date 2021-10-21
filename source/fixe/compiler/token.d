module fixe.compiler.token;

enum TokenType
{
    error,
    end,
}

struct Token
{
    uint         type;
    const(char) *start;
    uint         length;
    uint         line;
    uint         column;
}