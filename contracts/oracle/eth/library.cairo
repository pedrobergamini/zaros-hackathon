// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.uint256 import Uint256

namespace ETHOracle {
    func quote{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        eth_amount: Uint256
    ) -> (res: Uint256) {
        let (
            eth_price, decimals, timestamp, num_sources_aggregated
        ) = IEmpiricOracle.get_spot_median(EMPIRIC_ORACLE_ADDRESS, PAIR_ID);
        let (usd_for_eth_denorm: Uint256) = SafeUint256.mul(eth_price, eth_amount);
        let (res: Uint256, _) = SafeUint256.div_rem(usd_for_eth_denorm, Uint256(10 ** 10, 0));
        return (res,);
    }
}
