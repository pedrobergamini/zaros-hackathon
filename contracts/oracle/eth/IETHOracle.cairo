// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IETHOracle {
    func quote(eth_amount: Uint256) -> (res: Uint256) {
    }
}
