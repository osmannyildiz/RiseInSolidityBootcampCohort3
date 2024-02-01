// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ProposalContract {
    struct Proposal {
        string description;
        uint256 approve_count;
        uint256 reject_count;
        uint256 pass_count;
        uint256 total_vote_count_to_end;
        bool current_state;
        bool is_active;
    }

    mapping(uint256 => Proposal) proposals;
}
