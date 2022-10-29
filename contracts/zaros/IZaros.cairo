// SPDX-License-Identifier: MIT
%lang starknet

using address = felt;
using bool = felt;

struct zToken {
    token: address,
    price_feed: address,
}

struct Collateral {
    token: address,
    is_usd: bool,
}

@contract_interface
namespace IZaros {
    func debtTotalSupply() -> (res: felt) {
    }

    func totalAccumulatedFees() -> (res: felt) {
    }

    func protocolDebtUsd() -> (res: felt) {
    }

    func spotExchange() -> (res: felt) {
    }

    func debtShares(user: address) -> (res: felt) {
    }

    func accumulatedFeesFor(user: address) -> (res: felt) {
    }

    func zusdDebtFor(user: address) -> (res: felt) {
    }

    func mintShares(user: address, amount: felt) -> (success: bool) {
    }

    func burnShares(user: address, amount: felt) -> (success: bool) {
    }

    func updateFees(fee: felt) -> (success: bool) {
    }
}
