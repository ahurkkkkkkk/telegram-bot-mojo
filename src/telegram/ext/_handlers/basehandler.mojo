#!/usr/bin/env mojo
#
# Native handler foundation corresponding to telegram.ext._handlers.basehandler.
# LGPL-3.0-or-later; see LICENSE.

"""Synchronous contracts and block-default behavior for update handlers.

The Mojo 1.1 target does not safely compile generic async methods over arbitrary
update/context types or raising async callbacks. This module ports the typed
check, context-hook, and block-default behavior that the compiler can verify;
callback storage and awaited result propagation remain explicitly incomplete.
"""

from telegram._utils.defaultvalue import DEFAULT_TRUE, DefaultValue


struct BaseHandler(Copyable):
    """Typed synchronous portion of the native update-handler base."""

    var block: DefaultValue[Bool]

    def __init__(out self, block: DefaultValue[Bool] = DEFAULT_TRUE):
        self.block = block

    def __init__(out self, block: Bool):
        self.block = DefaultValue[Bool](block)

    def resolve_block(self, application_default: Bool) -> Bool:
        """Use the application-level default only for the sentinel value."""
        if self.block.is_sentinel:
            return application_default
        return self.block.unwrap()

    def check_update[
        Update: Copyable & Deinitable,
        CheckResult: Copyable & Deinitable,
        Checker: def(Update) -> CheckResult,
    ](self, checker: Checker, update: Update) -> CheckResult:
        """Run the concrete handler's update check."""
        return checker(update)

    def collect_additional_context[
        Context: Copyable & Deinitable,
        Update: Copyable & Deinitable,
        Application: Copyable & Deinitable,
        CheckResult: Copyable & Deinitable,
    ](
        self,
        context: Context,
        update: Update,
        application: Application,
        check_result: CheckResult,
    ) -> Context:
        """Default no-op hook returns the original context value."""
        return context.copy()

    def collect_context_with[
        Context: Copyable & Deinitable,
        Update: Copyable & Deinitable,
        Application: Copyable & Deinitable,
        CheckResult: Copyable & Deinitable,
        Collector: def(Context, Update, Application, CheckResult) -> Context,
    ](
        self,
        collector: Collector,
        context: Context,
        update: Update,
        application: Application,
        check_result: CheckResult,
    ) -> Context:
        """Run a handler-specific context hook and return its updated value."""
        return collector(context, update, application, check_result)
