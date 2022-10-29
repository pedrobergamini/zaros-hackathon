// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from contracts.zaros.library import Zaros

using address = felt;

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    spot_exchange: address, vaults_manager: address
) {
    Zaros.initialize(spot_exchange, vaults_manager);
    return ();
}

@view
func debtTotalSupply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    res: Uint256
) {
    let (res: Uint256) = Zaros.debt_total_supply();
    return (res,);
}

@view
func totalAccumulatedFees{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    res: Uint256
) {
    let (res: Uint256) = Zaros.total_accumulated_fees();
    return (res,);
}

@view
func protocolDebtUsd{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    res: Uint256
) {
    let (res: Uint256) = Zaros.protocol_debt_usd();
    return (res,);
}

@view
func spotExchange{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    res: address
) {
    let (res: address) = Zaros.spot_exchange();
    return (res,);
}

@view
func debtShares{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(user: address) -> (
    res: Uint256
) {
    let (res: Uint256) = Zaros.debt_shares(user);

    return (res,);
}

@view
func accumulatedFeesFor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    user: address
) -> (res: Uint256) {
    let (res: Uint256) = Zaros.accumulated_fees_for(user);

    return (res,);
}

@view
func zusdDebtFor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    user: address
) -> (res: Uint256) {
    let (res: Uint256) = Zaros.zusd_debt_for(user);

    return (res,);
}

@external
func mintShares{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    user: address, amount: Uint256
) -> (success: felt) {
    Zaros.mint_shares(user, amount);

    return (TRUE,);
}

@external
func burnShares{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    user: address, amount: Uint256
) -> (success: felt) {
    Zaros.burn_shares(user, amount);

    return (TRUE,);
}

@external
func updateFees{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(fee: Uint256) -> (
    success: felt
) {
    Zaros.update_fees(fee);

    return (TRUE,);
}
