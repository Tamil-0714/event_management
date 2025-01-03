// Protect Routes
function ensureAdminAuthenticated(req, res, next) {
  if (req?.session?.user?.role === "admin") {
    return next();
  } else {
    return res.redirect("/admin/login");
  }
}
function adminLogged(req, res, next) {
  if (req?.session?.user?.role === "admin") {
    res.redirect("/admin/dashboard");
  } else {
    next();
  }
}
function organiserLogged(req, res, next) {
  if (req?.session?.user?.role === "organiser") {
    return res.redirect("/organiser/dashboard");
  } else {
    return next();
  }
}
function partispantLogged(req, res, next) {
  if (req?.session?.user?.role === "partispant") {
    return res.redirect("/partispant/dashboard");
  } else {
    return next();
  }
}
function ensureOrganiserAuthenticated(req, res, next) {
  if (req?.session?.user?.role === "organiser") {
    return next();
  } else {
    return res.redirect("/organiser/login");
  }
}
function ensurePartispantAuthenticated(req, res, next) {
  if (req?.session?.user?.role === "partispant") {
    return next();
  } else {
    return res.redirect("/partispant/login");
  }
}
module.exports = {
  ensureOrganiserAuthenticated,
  ensureAdminAuthenticated,
  ensurePartispantAuthenticated,
  adminLogged,
  organiserLogged,
  partispantLogged,
};