function assignRoles(user, context, callback) {
  const namespace = "${audience}";

  if (context.authorization && context.authorization.roles) {
    const assignedRoles = context.authorization.roles;

    if (context.idToken) {
      const idTokenClaims = context.idToken;
      idTokenClaims[`${audience}/roles`] = assignedRoles;
      context.idToken = idTokenClaims;
    }

    if (context.accessToken) {
      const accessTokenClaims = context.accessToken;
      accessTokenClaims[`${audience}/roles`] = assignedRoles;
      context.accessToken = accessTokenClaims;
    }
  }

  callback(null, user, context);
}
