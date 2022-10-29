%lang starknet

from contracts.utils.constants.library import address

using address = felt;

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

    func mintShares(user: address, amount: felt) -> (success: felt) {
    }

    func burnShares(user: address, amount: felt) -> (success: felt) {
    }

    func updateFees(fee: felt) -> (success: felt) {
    }
}
