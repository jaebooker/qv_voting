pragma solidity >=0.4.25 <0.6.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/access/roles/MinterRole.sol";
import "./QVVoting.sol";

/**
 * @title VoteToken
 * @dev The VoteToken represents the credits that each user is awarded periodically.
 */
contract VoteToken is Ownable, MinterRole {
    using SafeMath for uint256;

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Voted(address indexed to, uint tokens);

    uint256 private _totalSupply;
    string public symbol;
    string public name;

    QVVoting qv_contract;

    mapping(address => uint256) private _balances;

    constructor(address _voting_contract) public {
        symbol = "VOTE";
        name = "Voting Token";
        qv_contract = QVVoting(_voting_contract);
        mint(msg.sender, 1000000000000000); // adds some starting tokens
    }

    /**
    * @dev Transfer the voice credits to the QVVoting contract.
    * @param proposal_id the proposal id
    * @param amount the amount of voice credits
    * @param vote true for yes, false for no
    */
    function castVote(uint256 proposal_id, uint256 amount, bool vote)
        public
        returns (bool)
    {
        require(
            msg.sender != address(0),
            "VotingToken: transfer from the zero address"
        );
        _balances[msg.sender] = _balances[msg.sender].sub(amount);
        qv_contract.castVote(proposal_id, amount, vote);

        emit Voted(address(qv_contract), amount);

        return true;
    }

    /**
    * @dev simple credits transfer function
    */
    function transfer(address to, uint tokens)
        public
        onlyOwner
        returns (bool success)
    {
        _balances[msg.sender] = _balances[msg.sender].sub(tokens);
        _balances[to] = _balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    /**
    * @dev minting more tokens for the owner of the contract
    */
    function mint(address account, uint256 amount) public onlyOwner {
        require(account != address(0), " mint to the zero address");
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
    }

    /**
    * @dev returns the balance of an account
    */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
    * @dev returns the voting contract address
    */
    function getVotingContractAddress() public view returns (address) {
        return address(qv_contract);
    }
}
