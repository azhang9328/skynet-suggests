document.addEventListener("DOMContentLoaded", () => {
  userSignUpForm()
  userLoginForm()
})

let currentUser = null

function userLoginForm(){
  let login = document.getElementById("user-login")
  login.addEventListener("submit", (event) => {
    event.preventDefault()
    let user = {name: event.target.name.value}
    loginUser(user)
  })
}

function loginUser(user){
  fetch('http://localhost:3000/users')
  .then(res => res.json())
  .then(data => {
    usersCheck(data, user)
  })
  .catch(err => console.log(err))
}

function usersCheck(data, user){
  let h3 = document.getElementById("current-user")
  let userExists = data.find(u => {
    return u.name == user.name
  })
  if(userExists.name){
    currentUser = user
    h3.innerText = currentUser.name
  } else {
    alert("No Such User, Try Again!")
  }
}

function userSignUpForm(){
  let signUp = document.getElementById("user-sign-up")
  signUp.addEventListener("submit", (event) => {
    event.preventDefault()
    let user = {name: event.target.name.value}
    persistUser(user)
  })
}

function persistUser(user){
  fetch('http://localhost:3000/users/', {
    method: 'POST',
    headers: {"Content-Type": "application/json",
              Accept: "application/json"
            },
    body: JSON.stringify(user)         
  })
  .then(res => console.log(res))
  .catch(err => console.log(err))
}

function getRepos() {
    fetch('http://localhost:3000/repos/')
    .then(res => res.json())
    .then(data => showRepos(data))
    .catch(err => console.log(err))
}

function newRepoForm(){

    let main = document.getElementById("main")

    let div = document.createElement("div")
    div.className = "card"

    div.innerHTML = "";

    let nickname = document.createElement("p")
    nickname.textContent = "Enter the nickname of your repository"

    let nicknameInput = document.createElement("input")
    nicknameInput.type = "text";
    
    let p = document.createElement("p")
    p.textContent = "Enter the Url of your repository"

    let input = document.createElement("input")
    input.type = "text";

    let button = document.createElement("button")
    button.textContent = "Submit Repository"
    button.addEventListener("click", () => {
        addRepository()
    })
    

    div.appendChild(nickname)
    div.appendChild(nicknameInput)
    div.appendChild(p)
    div.appendChild(input)
    div.appendChild(button)
    main.appendChild(div)
}

let button = document.getElementById("new-repo-form-button")
button.textContent = "Add a Repository"
button.addEventListener("click", () => {
    newRepoForm()
})