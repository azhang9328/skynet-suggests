document.addEventListener("DOMContentLoaded", () => {
  userSignUp()
})

function userSignUp(){
  let signUp = document.getElementById("user-login")
  signUp.addEventListener("submit", (event) => {
    event.preventDefault()
    console.log(event.target.name.value)
  })
}

function persistUser(){
    fetch()
}