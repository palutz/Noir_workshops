use dep::value_note::value_note::ValueNote;
use dep::aztec::protocol_types::{address::AztecAddress, abis::function_selector::FunctionSelector};

contract Crowfunding {
  #[aztec(storage)]
  struct Storage {
    // Token used for donations (e.g. DAI)
    donation_token: SharedImmutable<AztecAddress>,
    // Crowdfunding campaign operator
    operator: SharedImmutable<AztecAddress>,
    // End of the crowdfunding campaign after which no more donations are accepted
    deadline: PublicImmutable<u64>,
    // Notes emitted to donors when they donate (can be used as proof to obtain rewards, eg in Claim contracts)
    donation_receipts: PrivateSet<ValueNote>,
  }

  #[aztec(public)]
  #[aztec(initializer)]
  fn init(donation_token: AztecAddress, operator: AztecAddress, deadline: u64) {
    storage.donation_token.initialize(donation_token);
    storage.operator.initialize(operator);
    storage.deadline.initialize(deadline);
  }

  #[aztec(public)]
  #[aztec(internal)]
  fn _check_deadline() {
      let deadline = storage.deadline.read();
      assert(context.timestamp() < deadline, "Deadline has passed");
  }
}


#[aztec(private)]
fn donate(amount: u64) {
    // 1) Check that the deadline has not passed
    context.call_public_function(
        context.this_address(),
        FunctionSelector::from_signature("_check_deadline()"),
        []
    );
  //...
}
