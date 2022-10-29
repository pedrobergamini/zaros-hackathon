// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from contracts.zaros.IZaros import zToken, Collateral
from contracts.zaros.library import Zaros

using address = felt;
using bool = felt;

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    spot_exchange: address,
    vaults_manager: address,
    zeth: zToken,
    eth_oracle: address,
    zusd: address,
    collateral_tokens_len: felt,
    collateral_tokens: Collateral*,
) {
    Zaros.initialize(
        spot_exchange,
        vaults_manager,
        zeth,
        eth_oracle,
        zusd,
        collateral_tokens_len,
        collateral_tokens,
    );
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
) -> (success: bool) {
    Zaros.mint_shares(user, amount);

    return (TRUE,);
}

@external
func burnShares{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    user: address, amount: Uint256
) -> (success: bool) {
    Zaros.burn_shares(user, amount);

    return (TRUE,);
}

@external
func updateFees{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(fee: Uint256) -> (
    success: bool
) {
    Zaros.update_fees(fee);

    return (TRUE,);
}
