#[starknet::contract]
mod Bobby {
    use starknet::ContractAddress;
    use openzeppelin::token::erc20::{ERC20Component, ERC20HooksEmptyImpl};
    use openzeppelin::token::erc20::erc20::ERC20Component::InternalTrait;

    use ethdam::components::paris::paris::ParisComponent;

    //
    // Components
    //

    component!(path: ERC20Component, storage: erc20, event: ERC20Event);
    component!(path: ParisComponent, storage: paris, event: ParisEvent);

    #[abi(embed_v0)]
    impl ERC20MixingImpl = ERC20Component::ERC20MixinImpl<ContractState>;

    #[abi(embed_v0)]
    impl ParisImpl = ParisComponent::ParisImpl<ContractState>;

    //
    // Storage
    //

    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc20: ERC20Component::Storage,
        #[substorage(v0)]
        paris: ParisComponent::Storage,
    }

    //
    // Events
    //

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC20Event: ERC20Component::Event,
        #[flat]
        ParisEvent: ParisComponent::Event,
    }

    //
    // Constructor
    //

    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: ByteArray,
        symbol: ByteArray,
        fixed_supply: u256,
        recipient: ContractAddress
    ) {
        self.erc20.initializer(:name, :symbol);
        self.erc20._mint(:recipient, amount: fixed_supply);
    }
}
