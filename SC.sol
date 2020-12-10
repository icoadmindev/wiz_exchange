pragma solidity ^0.7.0;

import "./Ownable.sol";
import "./SafeMath.sol";
import "./Roles.sol";
import "./Token_interface.sol";


contract AdminRole is Context, Ownable {
    using Roles for Roles.Role;
    using SafeMath for uint256;

    uint256 private _qty_admins = 0;
    Roles.Role private _admins;
    address[] private _signatures;

    constructor () public {
      _qty_admins += 1;
      _admins.add(address(0x8186a47C412f8112643381EAa3272a66973E32f2));

      _qty_admins += 1;
      _admins.add(address(0xEe3EA17E0Ed56a794e9bAE6F7A6c6b43b93333F5));
    }

    modifier onlyAdmin() {
        require(isAdmin(_msgSender()), "AdminRole: you don't have permission to perform that action");
        _;
    }

    modifier onlyOwnerOrAdmin() {
      require(isAdminOrOwner(_msgSender()), "you don't have permission to perform that action");
      _;
    }

    function isAdminOrOwner(address account) public view returns (bool) {
        return isAdmin(account) || isOwner();
    }

    function isAdmin(address account) public view returns (bool) {
        return _admins.has(account);
    }

    //adding a signature for the next operation
    function addSignature4NextOperation() public onlyOwnerOrAdmin {
      bool exist = false;
      for(uint256 i=0; i<_signatures.length; i++){
        if(_signatures[i] == _msgSender()){
          exist = true;
          break;
        }
      }
      require(!exist, "You signature already exists");
      _signatures.push(_msgSender());
    }
    // removing a signature for the next operation
    function cancelSignature4NextOperation() public onlyOwnerOrAdmin {
      for(uint256 i=0; i<_signatures.length; i++){
        if(_signatures[i] == _msgSender()){
          _remove_signatures(i);
          return;
        }
      }
      require(false, "not found");

    }

    function checkValidMultiSignatures() public view returns(bool){
      uint256 all_signatures = _qty_admins + 1; // 1 for owner
      if(all_signatures <= 2){
        return all_signatures == _signatures.length;
      }
      uint256 approved_signatures = all_signatures.mul(2).div(3);
      return _signatures.length >= approved_signatures;
    }

    function revokeAllMultiSignatures() public onlyOwnerOrAdmin{
      uint256 l = _signatures.length;
      for(uint256 i=0; i<l; i++){
        _signatures.pop();
      }
    }

    function checkExistSignature(address account) public view returns(bool){
      bool exist = false;
      for(uint256 i=0; i<_signatures.length; i++){
        if(_signatures[i] == account){
          exist = true;
          break;
        }
      }
      return exist;
    }

    function _remove_signatures(uint index) private {
      if (index >= _signatures.length) return;
      for (uint i = index; i<_signatures.length-1; i++){
        _signatures[i] = _signatures[i+1];
      }
      _signatures.pop();
    }

}


contract SmartContract is AdminRole{
  using SafeMath for uint256;

  event BurningRequiredValues(uint256 allowed_value, uint256 topay_value, address indexed sc_address, uint256 sc_balance);

  Token_interface public token;
  uint256 private _token_exchange_rate = 273789679021000; //0.000273789679021 ETH per 1 token

  mapping(address => uint256) private _burnt_amounts;
  uint256 private _totalburnt = 0;
  address payable[] private _participants;

  mapping(address => bool) private _participants_with_request;

  struct PhaseParams{
    string NAME;
    bool IS_STARTED;
    bool IS_FINISHED;
  }

  PhaseParams[] public phases;
  uint256 constant PHASES_COUNT = 4;

  constructor () public {

    token = Token_interface(address(0x2F9b6779c37DF5707249eEb3734BbfC94763fBE2));

    // 0 - first
    PhaseParams memory phaseFirst;
    phaseFirst.NAME = "Initialize";
    phaseFirst.IS_STARTED = false;
    phaseFirst.IS_FINISHED = false;
    phases.push(phaseFirst);

    // 1 - second
    // tokens exchanging is active in this phase, tokenholders may burn their tokens using
    // one of the following methods:
    // method 1: tokenholder has to call approve(params: this SC address, amount in
    //           uint256) method in Token SC, then he/she has to call refund()
    //           method in this SC, all tokens from amount will be exchanged and the
    //           tokenholder will receive his/her own ETH on his/her own address
    // method 2: tokenholder has to call approve(params: this SC address, amount in
    //           uint256) method in Token SC, then he/she has to call
    //           refundValue(amount in uint256) method in this SC, all tokens
    //           from the refundValue's amount field will be exchanged and the
    //           tokenholder will receive his/her own ETH on his/her own address
    // method 3: if somebody accidentally sends tokens to this SC directly you may use
    //           refundTokensTransferredDirectly(params: tokenholder ETH address, amount in
    //           uint256) method with mandatory multisignatures
    PhaseParams memory phaseSecond;
    phaseSecond.NAME = "the First Phase";
    phaseSecond.IS_STARTED = false;
    phaseSecond.IS_FINISHED = false;
    phases.push(phaseSecond);

    // 2 - third
    // in this phase tokeholders who exchanged their own tokens in phase 1 may claim a
    // remaining ETH stake with register() method
    PhaseParams memory phaseThird;
    phaseThird.NAME = "the Second Phase";
    phaseThird.IS_STARTED = false;
    phaseThird.IS_FINISHED = false;
    phases.push(phaseThird);

    // 3 - last
    // this is a final distribution phase. Everyone who left the request during the
    // phase 2 with register() method will get remaining ETH amount
    // in proportion to their exchanged tokens
    PhaseParams memory phaseFourth;
    phaseFourth.NAME = "Final";
    phaseFourth.IS_STARTED = false;
    phaseFourth.IS_FINISHED = false;
    phases.push(phaseFourth);

    assert(PHASES_COUNT == phases.length);

    phases[0].IS_STARTED = true;
  }

  //
  // ####################################
  //
  
  //only owner or admins can top up the smart contract with ETH
  receive() external payable {
    require(isAdminOrOwner(_msgSender()), "the contract can't receive amount from this address");
  }

  // owner or admin may withdraw ETH from this SC, multisig is mandatory
  function withdrawETH(address payable recipient, uint256 value) public onlyOwnerOrAdmin{
    require(checkValidMultiSignatures(), "multisig is mandatory");
    recipient.send(value);
    revokeAllMultiSignatures();
  }

  function getExchangeRate() public view returns(uint256){
    return _token_exchange_rate;
  }

  function getBurntAmountByAddress(address holder) public view returns(uint256){
    return _burnt_amounts[holder];
  }

  function getBurntAmountTotal() public view returns (uint256) {
      return _totalburnt;
  }

  function getParticipantAddressByIndex(uint256 index) public view returns(address){
    return _participants[index];
  }

  function getNumberOfParticipants() public view returns(uint256){
    return _participants.length;
  }

  function getRegistrationStatus(address participant) public view returns(bool){
    return _participants_with_request[participant];
  }

  //
  // ####################################
  //
  // tokenholder has to call approve(params: this SC address, amount in uint256)
  // method in Token SC, then he/she has to call refund() method in this
  // SC, all tokens from amount will be exchanged and the tokenholder will receive
  // his/her own ETH on his/her own address
  function refund() public{
    address sender = _msgSender();
    uint256 allowed_value = token.allowance(sender, address(this));
    refundValue(allowed_value);
  }
  // tokenholder has to call approve(params: this SC address, amount in uint256)
  // method in Token SC, then he/she has to call refundValue(amount in
  // uint256) method in this SC, all tokens from the refundValue's amount
  // field will be exchanged and the tokenholder will receive his/her own ETH on his/her
  // own address
  function refundValue(uint256 value) public{
    uint256 i = getCurrentPhaseIndex();
    require(i == 1 && !phases[i].IS_FINISHED, "Not Allowed phase"); // First phase

    address payable sender = _msgSender();
    uint256 allowed_value = token.allowance(sender, address(this));
    bool is_allowed = allowed_value >= value;

    require(is_allowed, "Not Allowed value");

    uint256 topay_value = (value * _token_exchange_rate).div(10**18);
    BurningRequiredValues(allowed_value, topay_value, address(this), address(this).balance);
    require(address(this).balance >= topay_value, "Insufficient funds");

    require(token.transferFrom(sender, address(0x0000000000000000000000000000000000000000), value), "Error with transferFrom");

    if(_burnt_amounts[sender] == 0){
      _participants.push(sender);
    }

    _burnt_amounts[sender] = _burnt_amounts[sender].add(value);
    _totalburnt = _totalburnt.add(value);


    sender.send(topay_value);
  }
  // if somebody accidentally sends tokens to this SC directly you may use
  // burnTokensTransferredDirectly(params: tokenholder ETH address, amount in
  // uint256)
  // requires multisig 2/3
  function refundTokensTransferredDirectly(address payable participant, uint256 value) public onlyOwnerOrAdmin{
    uint256 i = getCurrentPhaseIndex();
    require(i == 1, "Not Allowed phase"); // First phase

    require(checkValidMultiSignatures(), "multisig is mandatory");

    uint256 topay_value = (value * _token_exchange_rate).div(10**token.decimals());
    require(address(this).balance >= topay_value, "Insufficient funds");

    require(token.transfer(address(0x0000000000000000000000000000000000000000), value), "Error with transfer");

    if(_burnt_amounts[participant] == 0){
      _participants.push(participant);
    }

    _burnt_amounts[participant] = _burnt_amounts[participant].add(value);
    _totalburnt = _totalburnt.add(value);

    participant.send(topay_value);
    revokeAllMultiSignatures();
  }
  // This is a final distribution after phase 2 is fihished, everyone who left the
  // request with register() method will get remaining ETH amount
  // in proportion to their exchanged tokens
  // requires multisig 2/3
  function startFinalDistribution() public onlyOwnerOrAdmin{
    uint256 i = getCurrentPhaseIndex();
    require(i == 3 && !phases[i].IS_FINISHED, "Not Allowed phase"); // Final Phase

    require(checkValidMultiSignatures(), "multisig is mandatory");

    uint256 total_balance = address(this).balance;
    uint256 sum_burnt_amount = getRefundedAmountByRequests();
    
    uint256 pointfix = 1000000000000000000; // 10^18
    for (uint i = 0; i < _participants.length; i++) {
      uint256 piece = getBurntAmountByAddress(_participants[i]) * pointfix / sum_burnt_amount;
      uint256 value = (total_balance * piece) / pointfix;
      if(value > 0){ _participants[i].send(value); }
    }

    revokeAllMultiSignatures();
  }

  function getRefundedAmountByRequests() public view returns(uint256){
    uint256 sum_burnt_amount = 0;
    for (uint i = 0; i < _participants.length; i++) {
      sum_burnt_amount += getBurntAmountByAddress(_participants[i]);
    }
    return sum_burnt_amount;
  }
  // tokeholders who exchanged their own tokens in phase 1 may claim a remaining ETH stake
  function register() public{
    _write_register(_msgSender());
  }

  // admin can claim register() method instead of tokenholder
  function forceRegister(address payable participant) public onlyOwnerOrAdmin{
    _write_register(participant);
  }

  function _write_register(address payable participant) private{
    uint256 i = getCurrentPhaseIndex();
    require(i == 2 && !phases[i].IS_FINISHED, "Not Allowed phase"); // Second phase

    require(_burnt_amounts[participant] > 0, "This address doesn't have exchanged tokens");

    _participants_with_request[participant] = true;
  }


  //
  // ####################################
  //

  function startNextPhase() public onlyOwnerOrAdmin{
    uint256 i = getCurrentPhaseIndex();
    require((i+1) < PHASES_COUNT);
    require(phases[i].IS_FINISHED);
    phases[i+1].IS_STARTED = true;
  }

  function finishCurrentPhase() public onlyOwnerOrAdmin{
    uint256 i = getCurrentPhaseIndex();
    phases[i].IS_FINISHED = true;

    if ((i+1) == PHASES_COUNT){ // is Finalize and Close
      // pass
    }
  }
  // this method reverts the current phase to the previous one
  function revertPhase() public onlyOwnerOrAdmin{
    uint256 i = getCurrentPhaseIndex();

    require(i > 0, "Initialize phase is active already");

    phases[i].IS_STARTED = false;
    phases[i].IS_FINISHED = false;

    phases[i-1].IS_STARTED = true;
    phases[i-1].IS_FINISHED = false;
  }

  function getPhaseName() public view returns(string memory){
    uint256 i = getCurrentPhaseIndex();
    return phases[i].NAME;
  }

  function getCurrentPhaseIndex() public view returns (uint256){
    uint256 current_phase = 0;
    for (uint256 i = 0; i < PHASES_COUNT; i++)
    {
      if (phases[i].IS_STARTED) {
        current_phase = i;
      }

    }
    return current_phase;
  }

}
