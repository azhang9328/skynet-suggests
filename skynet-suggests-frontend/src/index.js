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
  if(userExists){
    currentUser = userExists
    h3.innerText = currentUser.name
    renderRepos(currentUser)
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

function renderRepos(user) {
    user.repos.forEach(repo => {
        showRepo(repo)
    });
}


function showRepo(repo) {
    let analyzedRepositories = document.getElementById("analyzed-repositories")
    let unanalyzedRepositories = document.getElementById("unanalyzed-repositories")

    let div = document.createElement("div")

    let p = document.createElement("p")
    p.textContent = repo.nickname
    
    let u = document.createElement("p")
    u.textContent = repo.url

    let button = document.createElement("button")
    
    div.appendChild(p)
    div.appendChild(u)
    div.appendChild(button)

    if (repo.analyzed) {
        analyzedRepositories.appendChild(div)
        button.textContent = "See Analysis"
    } else {
        unanalyzedRepositories.appendChild(div)
        button.textContent = "Analyze Repo"
    }
}

function newRepoForm(){

    let main = document.getElementById("main")

    let form = document.createElement("form")
    // div.className = "card"

    // div.innerHTML = "";

    let nickname = document.createElement("p")
    nickname.textContent = "Enter the nickname of your repository"

    let nicknameInput = document.createElement("input")
    nicknameInput.type = "text";
    nicknameInput.name = "nickname";
    
    let p = document.createElement("p")
    p.textContent = "Enter the Url of your repository"

    let input = document.createElement("input")
    input.type = "text";
    input.name = "url"

    let button = document.createElement("button")
    button.textContent = "Submit Repository"

    form.addEventListener("submit", (event) => {
        event.preventDefault();
        console.log(event.target.nickname.value)
        let repo = {nickname: event.target.nickname.value, url: event.target.url.value, analyzed: false}
        // let repo = {nickname:}
        addRepository(repo)
    })
    

    form.appendChild(nickname)
    form.appendChild(nicknameInput)
    form.appendChild(p)
    form.appendChild(input)
    form.appendChild(button)
    main.appendChild(form)
}

let button = document.getElementById("new-repo-form-button")
button.textContent = "Add a Repository"
button.addEventListener("click", () => {
    newRepoForm()
})