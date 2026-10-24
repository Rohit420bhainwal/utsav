
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:utsav/routes/app_routes.dart';

import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          final isDesktop = width >= 900;
          final isTablet = width >= 600 && width < 900;

          final horizontalPadding = isDesktop
              ? 32.0
              : isTablet
              ? 40.0
              : 20.0;

          final cardMaxWidth = isDesktop ? 460.0 : 520.0;

          return Stack(
            children: [
              // Top background
              Container(
                height: height * (isDesktop ? 0.48 : 0.38),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.80),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),

              // Responsive page content
              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: isDesktop ? 32 : 20,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: height -
                          MediaQuery.of(context).padding.vertical -
                          (isDesktop ? 64 : 40),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 12),

                        Text(
                          'UTSAV',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'Turn moments into memories.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: isDesktop ? 36 : 28),

                        // Login card with a maximum width
                        Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: cardMaxWidth,
                            ),
                            child: Card(
                              elevation: 8,
                              color: Colors.white,
                              shadowColor: Colors.black26,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(
                                  isDesktop ? 32 : 24,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'LOGIN',
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 28),

                                    // Email
                                    TextFormField(
                                      controller: emailController,
                                      keyboardType:
                                      TextInputType.emailAddress,
                                      autofillHints: const [
                                        AutofillHints.email,
                                      ],
                                      decoration: const InputDecoration(
                                        labelText: 'Email',
                                        border: UnderlineInputBorder(),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // Password
                                    Obx(
                                          () => TextFormField(
                                        controller: passwordController,
                                        obscureText: !controller
                                            .isPasswordVisible.value,
                                        autofillHints: const [
                                          AutofillHints.password,
                                        ],
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          border:
                                          const UnderlineInputBorder(),
                                          suffixIcon: IconButton(
                                            tooltip: controller
                                                .isPasswordVisible.value
                                                ? 'Hide password'
                                                : 'Show password',
                                            icon: Icon(
                                              controller.isPasswordVisible
                                                  .value
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: controller
                                                .togglePasswordVisibility,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    // Forgot password
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed:
                                        controller.forgotPassword,
                                        child: const Text(
                                          'Forgot Password?',
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    // Login button
                                    Obx(
                                          () => SizedBox(
                                        height: 48,
                                        child: ElevatedButton(
                                          onPressed:
                                          controller.isLoading.value
                                              ? null
                                              : () => controller.login(
                                            emailController.text
                                                .trim(),
                                            passwordController
                                                .text
                                                .trim(),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(30),
                                            ),
                                          ),
                                          child: controller.isLoading.value
                                              ? const SizedBox(
                                            height: 22,
                                            width: 22,
                                            child:
                                            CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                              : const Text('LOGIN'),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // Sign-up footer
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                      WrapCrossAlignment.center,
                                      children: [
                                        const Text(
                                          "Don't have an account? ",
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.toNamed(AppRoutes.register);
                                          },
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets
                                                .symmetric(horizontal: 4),
                                            minimumSize: Size.zero,
                                            tapTargetSize:
                                            MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          child: const Text('Sign up'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}