use starknet::ContractAddress;

#[starknet::interface]
trait Paris<TState> {
    fn transfer_all(ref self: TState, to: ContractAddress);
}
