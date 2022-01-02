defmodule CookbookWeb.MultiStepWizardLive do
  use CookbookWeb, :live_view

  import Ecto.Changeset

  alias Cookbook.Books
  alias Cookbook.Books.Book

  defmodule Step1 do
    use Ecto.Schema

    schema "books" do
      field :title, :string
    end

    def changeset(book, attrs) do
      book |> cast(attrs, [:title]) |> validate_required([:title])
    end
  end

  defmodule Step2 do
    use Ecto.Schema

    schema "books" do
      field :summary, :string
    end

    def changeset(book, attrs) do
      book |> cast(attrs, [:summary])
    end
  end

  defmodule Step3 do
    use Ecto.Schema

    schema "books" do
      field :pages, :integer
    end

    def changeset(book, attrs) do
      book
      |> cast(attrs, [:pages])
      |> validate_required([:pages])
      |> validate_number(:pages, greater_than: 0)
      |> validate_number(:pages, less_than: 2000)
    end
  end

  def render(assigns) do
    ~H"""
    <div class="row">
      <.step step={1} current_step={@current_step} />
      <.step step={2} current_step={@current_step} />
      <.step step={3} current_step={@current_step} />
    </div>

    <.form let={f} for={@changeset} phx-change="validate" phx-submit="submit" novalidate>
      <%= if @current_step == 1 do %>
        <div class="mb-3">
          <%= label f, :title %>
          <%= text_input f, :title, class: "form-control", placeholder: "Enter title" %>
          <%= error_tag f, :title %>
        </div>
      <% end %>

      <%= if @current_step == 2 do %>
        <div class="mb-3">
          <%= label f, :summary %>
          <%= textarea f, :summary, class: "form-control", placeholder: "Add a short summary" %>
          <%= error_tag f, :summary %>
        </div>
      <% end %>

      <%= if @current_step == 3 do %>
        <div class="mb-3">
          <%= label f, :pages %>
          <%= number_input f, :pages, class: "form-control", placeholder: "Enter the number of pages" %>
          <%= error_tag f, :pages %>
        </div>
      <% end %>

      <div class="row mt-5">
        <%= if @current_step > 1 do %>
          <div class="col">
            <a phx-click="previous_step" class="btn btn-primary">Previous</a>
          </div>
        <% end %>

        <div class="col">
          <%= if @current_step < 3 do %>
            <a phx-click="next_step" class="btn btn-primary">Next</a>
          <% else %>
            <button type="submit" class="btn btn-primary">Add Book</button>
          <% end %>
        </div>
      </div>
    </.form>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, current_step: 1, params: %{}, changeset: Step1.changeset(%Book{}, %{}))}
  end

  def handle_event("previous_step", _params, socket) do
    socket =
      socket
      |> assign(current_step: socket.assigns.current_step - 1)
      |> assign(changeset: changeset_for(socket.assigns.current_step, socket.assigns.params))

    {:noreply, socket}
  end

  def handle_event("next_step", _params, socket) do
    changeset =
      changeset_for(socket.assigns.current_step, socket.assigns.params)
      |> Map.put(:action, :insert)

    socket =
      if changeset.valid? do
        socket
        |> assign(current_step: socket.assigns.current_step + 1)
        |> assign(changeset: changeset_for(socket.assigns.current_step, socket.assigns.params))
      else
        # We have validation errors so we stay on the same step
        socket |> assign(changeset: changeset)
      end

    {:noreply, socket}
  end

  def handle_event("validate", %{"book" => params}, socket) do
    changeset = changeset_for(socket.assigns.current_step, params) |> Map.put(:action, :insert)

    {:noreply,
     assign(socket, changeset: changeset, params: Map.merge(socket.assigns.params, params))}
  end

  def handle_event("submit", _params, socket) do
    case Books.create_book(socket.assigns.params) do
      {:ok, _book} ->
        {:noreply, socket |> put_flash(:info, "Book Added") |> assign(current_step: 1)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def step(assigns) do
    ~H"""
    <div class="col fs-3">
      <%= if assigns.current_step == assigns.step do %>
        <strong>Step <%= assigns.step %></strong>
      <% else %>
        Step <%= assigns.step %>
      <% end %>
    </div>
    """
  end

  defp changeset_for(step, params) do
    # Dynamically call the changeset function of the current step
    apply(String.to_existing_atom("#{__MODULE__}.Step#{step}"), :changeset, [%Book{}, params])
  end
end
