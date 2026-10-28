import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop/config/routes/routes_name.dart';
import 'package:shop/features/auth/auth_flow.dart';
import 'package:shop/features/auth/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final AuthService? auth;
  final Future<void> Function(AuthUser)? prepareAccount;
  const LoginScreen({super.key, this.auth, this.prepareAccount});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final mobile = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();
  late final AuthService auth = widget.auth ?? AuthService.instance;
  bool register = false;
  bool busy = false;
  bool hidden = true;
  bool confirmHidden = true;
  String? error;
  @override
  void dispose() {
    for (final controller in [name, email, mobile, password, confirm]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> finishLogin() async {
    await (widget.prepareAccount ?? prepareSignedInAccount)(auth.user!);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.bottom_bar,
      (_) => false,
    );
  }

  Future<void> submit() async {
    if (busy || !form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      busy = true;
      error = null;
    });
    try {
      if (register) {
        await auth.register(
          name: name.text,
          email: email.text,
          mobile: mobile.text,
          password: password.text,
          confirmPassword: confirm.text,
        );
      } else {
        await auth.login(mobile.text, password.text);
      }
      password.clear();
      confirm.clear();
      if (mounted) await finishLogin();
    } on Object catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> retrySession() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      if (await auth.restore()) {
        await finishLogin();
      } else if (mounted) {
        setState(() => error = auth.restoreError ?? 'फिर login करें।');
      }
    } on Object catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Widget gap() => const SizedBox(height: 16);
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF4F7EF),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: AutofillGroup(
              child: Form(
                key: form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.agriculture,
                      size: 64,
                      color: Color(0xFF2E7138),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Kisan Daily',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF225B2B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      register
                          ? 'अपना किसान खाता बनाएं'
                          : 'अपने खाते में लॉगिन करें',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'मोबाइल नंबर और password से प्रवेश करें',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    if (register) ...[
                      TextFormField(
                        key: const Key('auth_name'),
                        controller: name,
                        enabled: !busy,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.name],
                        decoration: const InputDecoration(
                          labelText: 'पूरा नाम *',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) =>
                            (value?.trim().length ?? 0) < 2 ||
                                value!.trim().length > 80
                            ? 'नाम 2–80 अक्षर में लिखें'
                            : null,
                      ),
                      gap(),
                      TextFormField(
                        key: const Key('auth_email'),
                        controller: email,
                        enabled: !busy,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        autocorrect: false,
                        decoration: const InputDecoration(
                          labelText: 'Email (वैकल्पिक)',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          final text = value?.trim() ?? '';
                          if (text.isEmpty) return null;
                          return text.length > 254 ||
                                  !RegExp(
                                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                  ).hasMatch(text)
                              ? 'सही email लिखें'
                              : null;
                        },
                      ),
                      gap(),
                    ],
                    TextFormField(
                      key: const Key('auth_mobile'),
                      controller: mobile,
                      enabled: !busy,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      autofillHints: register
                          ? const [AutofillHints.telephoneNumberNational]
                          : const [AutofillHints.username],
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                        labelText: 'मोबाइल नंबर *',
                        hintText: '9876543210',
                        prefixIcon: Icon(Icons.phone_outlined),
                        helperText: 'भारत का 10 अंकों का मोबाइल नंबर',
                      ),
                      validator: (value) =>
                          RegExp(
                            r'^[6-9]\d{9}$',
                          ).hasMatch(AuthService.normalizeMobile(value ?? ''))
                          ? null
                          : 'सही मोबाइल नंबर लिखें',
                    ),
                    gap(),
                    TextFormField(
                      key: const Key('auth_password'),
                      controller: password,
                      enabled: !busy,
                      obscureText: hidden,
                      autocorrect: false,
                      enableSuggestions: false,
                      textInputAction: register
                          ? TextInputAction.next
                          : TextInputAction.done,
                      autofillHints: [
                        register
                            ? AutofillHints.newPassword
                            : AutofillHints.password,
                      ],
                      onFieldSubmitted: (_) {
                        if (!register) submit();
                      },
                      decoration: InputDecoration(
                        labelText: 'Password *',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: hidden
                              ? 'Password दिखाएं'
                              : 'Password छिपाएं',
                          onPressed: () => setState(() => hidden = !hidden),
                          icon: Icon(
                            hidden
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Password लिखें';
                        if (utf8.encode(value).length > 72 ||
                            (register && value.length < 8))
                          return 'कम से कम 8 अक्षर; अधिकतम 72 UTF-8 bytes';
                        return null;
                      },
                    ),
                    if (register) ...[
                      gap(),
                      TextFormField(
                        key: const Key('auth_confirm'),
                        controller: confirm,
                        enabled: !busy,
                        obscureText: confirmHidden,
                        autocorrect: false,
                        enableSuggestions: false,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => submit(),
                        decoration: InputDecoration(
                          labelText: 'Confirm password *',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            tooltip: confirmHidden
                                ? 'Password दिखाएं'
                                : 'Password छिपाएं',
                            onPressed: () =>
                                setState(() => confirmHidden = !confirmHidden),
                            icon: Icon(
                              confirmHidden
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Password फिर लिखें'
                            : value != password.text
                            ? 'दोनों passwords एक जैसे होने चाहिए'
                            : null,
                      ),
                    ],
                    const SizedBox(height: 20),
                    if (error != null || auth.restoreError != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Semantics(
                          liveRegion: true,
                          child: Text(
                            error ?? auth.restoreError!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    FilledButton(
                      key: const Key('auth_submit'),
                      onPressed: busy ? null : submit,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      child: busy
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(register ? 'रजिस्टर करें' : 'लॉगिन करें'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      key: const Key('auth_toggle'),
                      onPressed: busy
                          ? null
                          : () => setState(() {
                              register = !register;
                              error = null;
                              password.clear();
                              confirm.clear();
                              form.currentState?.reset();
                            }),
                      child: Text(
                        register
                            ? 'पहले से खाता है? लॉगिन करें'
                            : 'नया खाता बनाएं • Register',
                      ),
                    ),
                    if (auth.restoreError != null)
                      TextButton(
                        onPressed: busy ? null : retrySession,
                        child: const Text('पिछला session फिर जांचें'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
