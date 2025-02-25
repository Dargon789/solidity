.. index:: ! custom storage layout, ! storage layout specifier, ! layout at, ! base slot

.. _custom-storage-layout:

*********************
Custom Storage Layout
*********************

Contracts can define an arbitrary base slot for its own storage.
The contract's state variables, including those inherited from base contracts,
will be stored from the specified slot instead of the default slot zero.

.. code-block:: solidity

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.29;

    contract C layout at 0xABCD + 0x1234 { }

As the previous example shows, this can be done by using ``layout at <base-slot-expression>``
in the header of a contract definition.

The layout specifier can be placed either before or after the inheritance specifier, and at most once.
The ``base-slot-expression`` must be an :ref:`integer literal<rational_literals>` expression
that can be evaluated at compile time and yield a value in the range of ``uint256``.

In the case of a custom storage layout specification which places the contract near the storage end,
the number of slots available for static objects is determined by ``max storage size - base slot`` and
the compiler can detect whether the contract extends past the end.
For dynamic typed variables, they are allocated in random locations of the storage, including those before
the layout base slot.
It is also important to mention that, in cases where the contract is near the end of storage, there are
risks related to upgradeability and inline assembly access beyond allocated space.

The location of a contract's state variable is determined by its position in the hierarchy tree.
Inherited variables will be stored before the state variables declared by the contract itself and
that changes the slots where they should be placed.
Similarly, when a contract specifies a custom storage layout, not only its own storage variables are shifted,
but also all other variables from contracts in the same inheritance tree.
Thus, the storage layout can only be specified at the top most contract of the inheritance tree, assuring
that all contracts of the tree have their layout base properly adjusted.

The storage layout cannot be specified for abstract contracts, interfaces and libraries.
Also, it is important to note that it does **not** affect transient state variables.

Further details are explained later when :ref:`layout of storage variables<storage-inplace-encoding>` are described.

.. warning::
    The identifiers ``layout`` and ``at`` are not reserved keywords of the Solidity language, but
    it is strongly recommended to avoid using them since that may change in the future.