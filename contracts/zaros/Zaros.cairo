// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from contracts.zaros.IZaros import zToken, Collateral
from contracts.zaros.library import Zaros
from contracts.oracle.eth.IETHOracle import IETHOracle
from openzeppelin.access.ownable.library import Ownable

using address = felt;
using bool = felt;

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    spot_exchange: address,
    zeth: zToken,
    eth_oracle: address,
    zusd: address,
    eth: address,
    dai: address,
    usdc: address,
    owner: address,
) {
    Zaros.initializer(spot_exchange, zeth, eth_oracle, zusd, eth, dai, usdc);
    Ownable.initializer(owner);
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
func setVaultsManager{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    vaults_manager: address
) {
    Ownable.assert_only_owner();
    Zaros.set_vaults_manager(vaults_manager);

    return ();
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
