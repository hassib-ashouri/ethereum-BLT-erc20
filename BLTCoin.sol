pragma solidity ^0.5.1;
contract BLTtoker
{
    string public constant symbol = "BLT";
    string public constant name = "Hassib Ashouri";
    mapping (address => uint) balances;
    mapping (address => mapping(address => uint)) allowed;
    mapping (address => bool) locked;
    uint public numAdresses = 0;
    uint private _totalSupply;
    address owner;

    constructor() public
    {
        _totalSupply = 10000000;
        owner = msg.sender;
        balances[0x94eE6d592fB7db644177dA75D1e4e27026f5e7d1] = 80;
        balances[0x0D04FBeBdFC783d091bAA76eD0cDdbBf03AAe552] = 100;
        locked[0x0D04FBeBdFC783d091bAA76eD0cDdbBf03AAe552] = true;
    }

    function totalSupply()
    public view
    returns (uint)
    {
        return _totalSupply;
    }
    
    function balanceOf(address tokenOwner) 
    public view 
    returns (uint balance)
    {
        return balances[tokenOwner];
    }
    
    function allowance(address tokenOwner, address spender)
    public view 
    returns (uint remaining)
    {
        return allowed[tokenOwner][spender];
    }
    
    function transfer(address to, uint tokens) 
    public 
    returns (bool success)
    {
        if(balances[msg.sender] < tokens || locked[to] || locked[msg.sender])
        {
            return false;
        }
        balances[msg.sender] -= tokens;
        balances[to] += tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
    
    function approve(address spender, uint tokens)
    public 
    returns (bool success)
    {
        if(balances[msg.sender] < tokens)
        {
            return false;
        }
        
        allowed[msg.sender][spender] += tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    
    function transferFrom(address from, address to, uint tokens)
    public
    returns (bool success)
    {
        if(allowed[from][to] < tokens || locked[from] || locked[to])
        {
            return false;
        }
        
        balances[from] -= tokens;
        allowed[from][to] -= tokens;
        balances[to] += tokens;
        emit Transfer(from, to, tokens);
        return true;
    }
    
    function freeze(address frozen)
    public
    {
        require(msg.sender == owner, "Unavailble functionality");
        locked[frozen] = true;
    }
    
    function thaw(address unfrozen)
    public
    {
        require(msg.sender == owner, "Unavailble functionality");
        locked[unfrozen] = false;
    }
    
    function burn(uint tokens)
    public
    returns (bool success)
    {
        if(balances[msg.sender] < tokens)
        {
            return false;
        }
        
        balances[msg.sender] -= tokens;
        _totalSupply -= tokens;
        return true;
    }
    
    event Transfer(address indexed from, address indexed to, uint tokens);

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


