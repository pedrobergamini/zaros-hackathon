// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from openzeppelin.security.safemath.library import SafeUint256

@external
func quote{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    eth_amount: Uint256
) -> (res: Uint256) {
    let eth_price = Uint256(1600 * 10 ** 8, 0);
    let (usd_for_eth_denorm: Uint256) = SafeUint256.mul(eth_price, eth_amount);
    let (res: Uint256, _) = SafeUint256.div_rem(usd_for_eth_denorm, Uint256(10 ** 10, 0));
    return (res,);
}
