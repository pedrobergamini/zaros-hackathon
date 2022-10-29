%lang starknet

@contract_interface
namespace IZaros {
    func debtTotalSupply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        res: felt
    ) {
    }

    func accumulatedFees{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        res: felt
    ) {
    }

    func protocolDebtUsd{syscall_ptr: felt, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        res: felt
    ) {
    }

    func debtShares{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: felt
    ) -> (res: felt) {
    }
}
