// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.8.26;

interface ExternalInitializer {
    event LogExternalInitialize(bytes data);

    function initialize(bytes calldata data) external;
}
