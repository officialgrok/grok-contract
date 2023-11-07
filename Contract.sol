// $GROK is the next AI, with humor.
// Website - https://grok-token.com/

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.8.10;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }
    
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }
    
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }
    
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; 
        return msg.data;
    }
}

library Address {
    
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
    
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }
    
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }
    
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }
    
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }
    
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }
    
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }
    
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                 assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);
    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);
    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);
    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);
    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;
    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract GROK is Context, IERC20 { 
    using SafeMath for uint256;
    using Address for address;
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) public _excludedFromFees;

    string private constant _Name = "GROK";
    string private constant _Symbol = "GROK";
    uint8 private constant _Decimals = 9;
    uint256 private _Supply = 1000000 * 10**_Decimals;
    address payable public MarketingWallet = payable(0xc2e12dF9e4080236b9D4e4834679CE447Ed9F61f);
    address payable public constant BurnWallet = payable(0x000000000000000000000000000000000000dEaD);
    uint256 public buyTax = 5;
    uint256 public sellTax = 5;

    uint256 public marketingPercentage = 100;
    uint256 public burnPercentage = 0;
    uint256 public _MaxWallet = _Supply * 3 / 100;

    uint8 private swapCounter = 0;
    uint8 private swap_Trigger = 10;
    bool public inSwapAndLiquify;
    bool public swapAndLiquifyEnabled = true;
    event SwapAndLiquifyEnabledUpdated(bool true_or_false);
    
    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;

    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }
    
    constructor () {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), _owner);

        _balances[owner()] = _Supply;
        
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); 
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        uniswapV2Router = _uniswapV2Router;

        _excludedFromFees[owner()] = true;
        _excludedFromFees[address(this)] = true;
        _excludedFromFees[MarketingWallet] = true; 
        _excludedFromFees[BurnWallet] = true;

        emit Transfer(address(0), owner(), _Supply);
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function name() public pure returns (string memory) {
        return _Name;
    }

    function symbol() public pure returns (string memory) {
        return _Symbol;
    }

    function decimals() public pure returns (uint8) {
        return _Decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _Supply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function allowance(address theOwner, address theSpender) public view override returns (uint256) {
        return _allowances[theOwner][theSpender];
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    receive() external payable {}

    function _getCurrentSupply() private view returns(uint256) {
        return (_Supply);
    }

    function _approve(address theOwner, address theSpender, uint256 amount) private {
        require(theOwner != address(0) && theSpender != address(0), "Error: Using 0 address!");
        _allowances[theOwner][theSpender] = amount;
        emit Approval(theOwner, theSpender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {

        if (to != owner() && to != BurnWallet && to != address(this) && to != uniswapV2Pair && from != owner()) {
            uint256 bagSize = balanceOf(to);
            if(!_excludedFromFees[from] || !_excludedFromFees[to])
            require((bagSize + amount) <= _MaxWallet, "Error: bag limit reached.");
        }

        require(from != address(0) && to != address(0), "Error: Using 0 address!");
        require(amount > 0, "Error: Amount must be higher than 0.");   

        if (swapCounter >= swap_Trigger && !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled) {  
            uint256 contractTokenBalance = balanceOf(address(this));
            
            if(contractTokenBalance > _MaxWallet) {
                contractTokenBalance = _MaxWallet;
            }

            swapCounter = 0;
            swapAndLiquify(contractTokenBalance);
        }
        
        bool feeUsed = true;
        bool isBuy;

        if(_excludedFromFees[from] || _excludedFromFees[to]) {
            feeUsed = false;
        } else {
            if (from == uniswapV2Pair) {
                isBuy = true;
            }
            swapCounter++;
        }
        _tokenTransfer(from, to, amount, feeUsed, isBuy);
    }
    
    function swapTriggerChange(uint8 newSwapTrigger) public {
        require(msg.sender == MarketingWallet, "Error: Swap Trigger can only be changed by the marketing team.");
        swap_Trigger = newSwapTrigger;
    }

    function swapAndLiquifyStatus(bool isEnabled) public {
        require(msg.sender == MarketingWallet, "Error: Swap & Liquify can only be enabled/disabled by the marketing team.");

        swapAndLiquifyEnabled = isEnabled;
        emit SwapAndLiquifyEnabledUpdated(isEnabled);
    }

    function percentageSplitChanger(uint256 mSplit, uint256 bSplit) public {
        require(msg.sender == MarketingWallet, "Error: Split percentage can only be modified by the marketing team.");

        marketingPercentage = mSplit;
        burnPercentage = bSplit;
    }

    function sendToWallet(address payable wallet, uint256 amount) private {
        wallet.transfer(amount);
    }

    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {

        uint256 tokens_to_Burn = contractTokenBalance * burnPercentage / 100;
        _Supply = _Supply - tokens_to_Burn;
        _balances[BurnWallet] = _balances[BurnWallet] + tokens_to_Burn;
        _balances[address(this)] = _balances[address(this)] - tokens_to_Burn; 

        uint256 tokensMarketing = contractTokenBalance * marketingPercentage / 100;

        uint256 balanceBeforeSwap = address(this).balance;
        swapTokensForBNB(tokensMarketing);
        uint256 TotalBNB = address(this).balance - balanceBeforeSwap;

        uint256 MarketingSize = marketingPercentage * 100 / marketingPercentage;
        uint256 MarketingBNB = TotalBNB * MarketingSize / 100;

        sendToWallet(MarketingWallet, MarketingBNB);
    }

    function swapTokensForBNB(uint256 tokenAmount) private {

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, 
            path,
            address(this),
            block.timestamp
        );
    }

    function _tokenTransfer(address sender, address recipient, uint256 tokenAmount, bool feeUsed, bool isBuy) private {
        
        if (!feeUsed) {

            _balances[sender] = _balances[sender] - tokenAmount;
            _balances[recipient] = _balances[recipient] + tokenAmount;

            emit Transfer(sender, recipient, tokenAmount);

            if (recipient == BurnWallet)
            _Supply = _Supply - tokenAmount;



            } else if (isBuy) {

            uint256 BuyFee = tokenAmount * buyTax/100;
            uint256 taxedTokenAmount = tokenAmount - BuyFee;

            _balances[sender] = _balances[sender] - tokenAmount;
            _balances[recipient] = _balances[recipient] + taxedTokenAmount;
            _balances[address(this)] = _balances[address(this)] + BuyFee;

            emit Transfer(sender, recipient, taxedTokenAmount);

            if (recipient == BurnWallet)
            _Supply = _Supply - taxedTokenAmount;
            


            } else {

            uint256 SellFee = tokenAmount * sellTax/100;
            uint256 taxedTokenAmount = tokenAmount - SellFee;

            _balances[sender] = _balances[sender] - tokenAmount;
            _balances[recipient] = _balances[recipient] + taxedTokenAmount;
            _balances[address(this)] = _balances[address(this)] + SellFee; 

            emit Transfer(sender, recipient, taxedTokenAmount);

            if (recipient == BurnWallet)
            _Supply = _Supply - taxedTokenAmount;

            }
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function excludeAddressFromFees(address[] calldata accounts, bool excluded) public {
        require(msg.sender == MarketingWallet, "Error: Only the marketing team can exclude wallets from fees, CEX Wallets, Swap Wallets, etc.");
        for(uint256 i = 0; i < accounts.length; i++) {
            _excludedFromFees[accounts[i]] = excluded;
        }
    }
}