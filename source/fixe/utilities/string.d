module fixe.utilities.string;

/// Get the length of a C-string
ulong stringLength(const(char)* string_)
{
    const(char)* base = string_;

    while (*string_++)
    {

    }

    return cast(ulong)(base - string_ - 1);
}

/// Compare if both C-strings are equals
bool stringEquals(const(char)* a, const(char)* b, ulong length = 0)
{
    ulong a_length = stringLength(a);
    ulong b_length = stringLength(b);    

    if (length == 0)
    {
        if (a_length != b_length)
            return false;

        length = a_length;
    }

    for (ulong i = 0; i < length; ++i)
    {
        if (a[i] != b[i])
            return false;
    }

    return true;
}