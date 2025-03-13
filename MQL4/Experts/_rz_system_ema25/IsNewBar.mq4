// The first call always returns true.
bool IsNewBar()
{
    static datetime prevOne = 0;
    
    if(Time[0] != prevOne)
    {
        prevOne = Time[0];

        return true;
    }
    
    return false;
}
